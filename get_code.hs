module Main where
import Text.Pandoc
import Text.Pandoc.Writers.Markdown
import qualified Data.Set as Set

doInclude :: Block -> IO Block
doInclude cb@(CodeBlock (id, classes, namevals) contents) =
  case lookup "include" namevals of
       Just f     -> return . (CodeBlock (id, classes, namevals)) =<< readFile f
       Nothing    -> return cb
doInclude x = return x

readDoc :: String -> Pandoc
readDoc = readMarkdown def

writeDoc :: Pandoc -> String
writeDoc = writeMarkdown def

main :: IO ()
main = getContents >>= bottomUpM doInclude . readDoc >>= putStrLn . writeDoc
