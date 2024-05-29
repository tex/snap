; Filter that can be passed to fzy consumer.
; It transforms user provided search string
; (filter) specific to ttags into fzy.
; ttags wild-card is %.
; Remove it so fzy can sort result nicely.
(fn [filter] (string.gsub filter "%%" ""))
