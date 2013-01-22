import Text.Pandoc

doInclude :: Block -> IO Block
doInclude cb@(CodeBlock (id, classes, namevals) contents) =
  case lookup "include" namevals of
       Just f     -> return . (CodeBlock (id, classes, namevals)) =<< readFile f
       Nothing    -> return cb
doInclude x = return x

readDoc :: String -> Pandoc
readDoc = readMarkdown defaultParserState

writeDoc :: Pandoc -> String
writeDoc = writeMarkdown defaultWriterOptions

main :: IO ()
main = getContents >>= bottomUpM doInclude . readDoc >>= putStrLn . writeDoc
