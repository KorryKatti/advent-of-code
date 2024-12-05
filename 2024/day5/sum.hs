import System.IO (readFile)

-- Main function to read middle.txt and calculate the sum
main :: IO ()
main = do
  -- Read contents of middle.txt
  contents <- readFile "middle.txt"
  let numbers = map read (lines contents) :: [Int]

  -- Calculate the sum
  let total = sum numbers

  -- Display the result
  putStrLn $ "The sum of numbers in middle.txt is: " ++ show total
