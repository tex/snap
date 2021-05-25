# Snap

A fast finder system for neovim.

## Installation

### With Packer

```
use 'camspiers/snap.nvim'
```

If you want to use the inbuilt support for `fzy`:

```
use_rocks 'fzy'
```

## Basic example

The following is a basic example to give a taste of the API. It creates a highly performant live grep `snap`.

```lua
snap.run {
  producer = require'snap.producer.ripgrep.vimgrep'.create,
  select = require'snap.select.vimgrep'.select
}
```

## Concepts

`snap` uses a non-blocking design to ensure the UI is always responsive to user input.

To achieve this `snap` employs coroutines, and while that might be a little daunting, the following walk through of the primary concepts of `snap` is designed to help put all the concepts together

Our example's goal is to run the `ls` command, filter the results in response to input, and print the selected value.

### Producer

A producers API looks like this:

```typescript
type Producer = (request: Request) => yield<Yieldable>;
```

The producer is a function that takes a request, and yields results (see below for the range of `Yieldable` types).

In the following `producer`, we run the `ls` command and progressively `yield` its output.

```lua
-- Runs ls and yields lua tables containing each line
local function producer (request)
  -- Runs the slow-mode getcwd function
  local cwd = snap.yield(vim.fn.getcwd)
  -- Iterates ls commands output using snap.io.spawn
  for data, err, kill in snap.io.spawn("ls", {}, cwd) do
    -- If the filter updates while the command is still running
    -- then we kill the process and yield nil
    if request.cancel then
      kill()
      coroutine.yield(nil)
    -- If there is an error we yield nil
    elseif (err ~= "") then
      coroutine.yield(nil)
    -- If the data is empty we yield an empty table
    elseif (data == "") then
      coroutine.yield({})
    -- If there is data we split it by newline
    else
      coroutine.yield(vim.split(data, "\n", true))
    end
  end
end
```

### Consumer

A consumers type looks like this:

```typescript
type Consumer = (producer: Producer) => Producer;
```

A consumer is a function that takes another producer and returns a producer which progressively yields its own results.

As our goal here is to filter, we iterate over our passed producer and only yield values that match `request.filter`.

```lua
-- Takes in a producer and returns a producer
local function consumer (producer)
  -- Return producer
  return function (request)
    -- Iterates over the producers results
    for results in snap.consume(producer, request) do
      -- If we have a table then we want to filter it
      if type(results) == "table" then
        -- Yield the filtered table
        coroutine.yield(vim.tbl_filter(
         function (value)
           return string.find(value, request.filter, 0, true)
         end,
         results
        ))
      -- If we don't have a table we finish by yielding nil
      else
        coroutine.yield(nil)
      end
    end
  end
end
```

### Producer + Consumer

The following combines our above `consumer` and `producer`, itself creating a new producer, and passes this to `snap` to run:

```lua
snap.run {
  producer = consumer(producer),
  select = print
}
```

From the above we have seen the following distinct concepts of `snap`:

- Producer + consumer pattern
- Yielding a lua `table` of strings
- Yielding `nil` to exit
- Using `snap.io.spawn` iterate over a processes data
- Using `snap.yield` to run slow-mode nvim functions
- Using `snap.consume` to consume another producer
- Using the `request.filter` value
- Using the `request.cancel` signal to kill processes

## Usage

`snap` comes with inbuilt producers and consumers to enable easy usage and creation of finders.

### Find Files

```lua
snap.run {
  producer = require'snap.consumer.fzy'.create(
    require'snap.producer.ripgrep.file'.create
  ),
  select = require'snap.select.file'.select
}
```

### Live Ripgrep

```lua
snap.run {
  producer = require'snap.producer.ripgrep.vimgrep'.create,
  select = require'snap.select.vimgrep'.select
}
```

### Find Buffers

```lua
snap.run {
  producer = require'snap.consumer.fzy'.create(
    require'snap.producer.buffer'.create
  ),
  select = require'snap.select.file'.select
}
```

### Find Old Files

```lua
snap.run {
  producer = require'snap.consumer.fzy'.create(
    require'snap.producer.oldfiles'.create
  ),
  select = require'snap.select.file'.select
}
```

## API

### Types

#### Meta Result

Results can be decorated with additional information (see `with_meta`),
these results are represented by the `MetaResult` type.

```typescript
// A table that tostrings as result

type MetaResult = {
  // The result string value
  result: string;

  // A metatable __tostring implementation
  __tostring: (result: MetaResult) => string;

  // More optional properties, e.g. score
  ...
};
```

#### Yieldable

Coroutines in `snap` can yield 4 different types, each with a distinct meaning outlined below.

```typescript
type Yieldable = table<string> | table<MetaResult> | function | nil;
```

#### Request

This is the request that is passed to a `producer`.

```typescript
type Request = {
  filter: string;
  cancel: boolean;
};
```

#### Producer

```typescript
type Producer = (request: Request) => yield<Yieldable>;
```

#### Consumer

```typescript
type Consumer = (producer: Producer) => Producer;
```

#### `snap.run`

```typescript
{
  // Get the results to display
  producer: (request: Request) => yield<Yieldable>;

  // Called on select
  select: (selection: string) => nil;

  // Optional prompt displayed to the user
  prompt?: string;

  // Optional function that enables multiselect
  multiselect?: (selections: table<string>) => nil;

  // Optional function configuring the results window
  layout?: () => {
    width: number;
    height: number;
    row: number;
    col: number;
  };
};
```

#### Yielding `table<string>`

For each `table<string>`  yielded (or returned as the last value of `producer`) to `snap` from `producer`, `snap` will accumulate the `string` values of the table and display them in the results buffer.

##### Example

```lua
local function producer(message)
  coroutine.yield({"Result 1", "Result 1"})
  coroutine.yield({"Result 3", "Result 4"})
end
```

This `producer` function results in a table of 4 values displayed, but given there are two yields, in between these yields `nvim` has an oppurtunity to process more input.

One can see how this functionality allows for results of spawned processes to progressively yield thier results while avoiding blocking user input, and enabling the cancelation of said spawned processes.

#### Yielding `table<MetaResult>`

Results at times need to be decorated with additional information, e.g. a sort score.

`snap` makes use of tables (with an attached metatable implementing `__tostring`) to represent results with meta data.

The following shows how to add results with additional information. And because `snap` automatically sorts results with `score` meta data, the following with be ordered accordingly.

```lua
local function producer(message)
  coroutine.yield({
    snap.with_meta("Higher rank", "score", 10),
    snap.with_meta("Lower rank", "score", 1),
    snap.with_meta("Mid rank", "score", 5)
  })
end
```

#### Yielding `function`

Given that `producer` is by design run when `fast-mode` is true. One needs an ability to at times get the result of a blocking `nvim` function, such as many of `nvim` basic functions, e.g. `vim.fn.getcwd`. As such `snap` provides the ability to `yield` a function, have its execution run with `vim.schedule` and its resulting value returned.

##### Example

```lua
local function producer(message)
  -- Yield a function to get its result
  local cwd = snap.yield(vim.fn.cwd)
  -- Now we have the cwd we can yield itable<string>
  coroutine.yield({cwd})
end
```

This results in a single result being displayed in the result buffer, in particular the `cwd`.

#### Yielding `nil`

Yielding nil signals to `snap` that there are not more results, and the coroutine is dead. `snap` will finish processing the `coroutine` when nil is encounted.

```lua
local function producer(message)
  coroutine.yield({"Result 1", "Result 1"})
  coroutine.yield(nil)
  -- Doesn't proces this, as coroutine is dead
  coroutine.yield({"Result 3", "Result 4"})
end
```

## Advanced API (for developers)

### `snap.meta_result`

Turns a result into a meta result.

```typescript
(result: string | MetaResult) => MetaResult
```

### `snap.with_meta`

Adds a meta field to a results.

```typescript
(result: string | MetaResult, field: string, value: any) => MetaResult
```

### `snap.has_meta`

```typescript
(result: string | MetaResult, field: string) => boolean
```

### `snap.resume`

Resumes a passed coroutine while handling non-fast API requests.

### `snap.yield`

```
(value: Yieldable) => any
```

Makes getting values from yield easier by skiping first coroutine.yield return value.

### `snap.consume`

```
(producer: Producer, request: Request) => iterator<yield<Yieldable>>
```

Consumes a producer

### `snap.layouts.centered`
### `snap.layouts.bottom`
### `snap.layouts.top`

