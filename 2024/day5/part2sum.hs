import System.IO (readFile)

-- Parse a line into an integer
parseLine :: String -> Int
parseLine = read . head . words

-- Main function to sum all elements from middle2.txt
main :: IO ()
main = do
  -- Read lines from middle2.txt
  contents <- readFile "middle2.txt"
  let numbers = map parseLine (lines contents)

  -- Calculate the sum of the numbers
  let totalSum = sum numbers

  -- Print the result
  putStrLn ("The sum of all elements is: " ++ show totalSum)
