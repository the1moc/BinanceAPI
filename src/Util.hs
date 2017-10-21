module Util where

import qualified Data.ByteString.Lazy.Char8 as LBString (ByteString, pack,
                                                         unpack)

-- Some of the API returns ["x", "y", []]
-- This removes that
removeEmptyListFromResponse :: LBString.ByteString -> LBString.ByteString
removeEmptyListFromResponse b = LBString.pack $ filterResponse $ LBString.unpack b

filterResponse :: String -> String
filterResponse [] = []
filterResponse [x] = [x]
filterResponse (',':'[':']':xs) = filterResponse xs
filterResponse (x:xs) = x : filterResponse xs
