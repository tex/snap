(local snap (require :snap))
(local parse (require :snap.common.grep.parse))
(local file (require :snap.select.common.file))
(local multifile (require :snap.select.common.multifile))

(local parse-selection
  (fn [selection]
    (local {: filename : lnum} (parse selection))
    {:filename (snap.topath filename) : lnum :col 0}))

(local select
  (file (fn [selection] (parse-selection selection))))

(local multiselect
  (multifile (fn [selection] (parse-selection selection))))

{: select
 : multiselect}
