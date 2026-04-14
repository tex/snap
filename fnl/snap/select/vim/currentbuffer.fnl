(local file (require :snap.select.common.file))

{:select (file (fn [{: filename :row lnum}] {: filename : lnum}))}
