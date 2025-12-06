(def input (slurp "./input.txt"))

(defn parse-input [i]
  (let [[r d] (clojure.string/split i #"\n\n")]
    {:ranges (map #(mapv parse-long (re-seq #"\d+" %)) (clojure.string/split-lines r))
     :ids (map parse-long (clojure.string/split-lines d))}))


(defn in-range? [id [start end]]
  (<= start id end))

(defn solve [{:keys [ranges ids]}]
  (count (filter #(some (partial in-range? %) ranges) ids)))


(defn merge-range [[s1 e1] [s2 e2]] [s1 (max e1 e2)])

(defn count-fresh [{:keys [ranges]}]
  (->> (sort ranges)
       (reduce (fn [acc r]
                 (if (and (seq acc) (<= (first r) (inc (second (last acc)))))
                   (conj (pop acc) (merge-range (last acc) r))
                   (conj acc r))) [])
       (map #(- (second %) (first %) -1))
       (apply +)))

(def data (parse-input input))

(def part1 (solve data))
(def part2 (count-fresh data))
