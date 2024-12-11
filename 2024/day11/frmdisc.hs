import qualified Data.Map as Map

type Counter = Map.Map Int Int

blink :: Counter -> Int -> Counter
blink nums 0 = nums
blink nums level = blink (next) (level - 1)
                   where
                   next = Map.fromListWith (+) (concatMap blinkify (Map.toList nums))

blinkify :: (Int, Int) -> [(Int, Int)]
blinkify (0, n) = [(1, n)]
blinkify (num, n)
                    | even l = [((div num ten), n), ((mod num ten), n)]
                    | otherwise = [(num * 2024, n)]
                    where
                    ten = 10 ^ (div l 2)
                    l = length s
                    s = show num

main = do
  let nums = [1750884, 193, 866395, 7, 1158, 31, 35216, 0]
  let numsMap = Map.fromListWith (+) [(i, 1) | i <- nums]
  let counts = blink numsMap 75
  let count = Map.foldl (+) 0 (counts)
  print count


-- had to take from discord , too much time using bruteforce