(module snap.layout)

;; Global accessible layouts
;; Currently layouts always have the input placed below and therefore room
;; must be left available for it to fit

;; Helper to get lines
(defn lines []
  (vim.api.nvim_get_option_value :lines {}))

;; Helper to get columns
(defn columns []
  (vim.api.nvim_get_option_value :columns {}))

(defn percent [size percent]
  (math.floor (* size percent)))

(fn size [%width %height]
  {:width (math.floor (* (columns) %width))
   :height (math.floor (* (lines) %height))})

(fn from-bottom [size offset]
  (- (lines) size offset))

;; Primary available layout: centered

(defn centered []
    {:input { :width (columns)
              :height 1
              :row (- (lines) 4)
              :col 0 }
     :results { :width (columns)
                :height 10
                :row (- (lines) 4 12)
                :col 0 }
     :view { :width (columns)
             :height (- (lines) 4 12 2)
             :row 0
             :col 0 }})
