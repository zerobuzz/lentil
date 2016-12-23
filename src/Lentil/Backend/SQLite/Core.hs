{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Lentil.Backend.SQLite.Core (
    SQLite
  , ID(..)
  , sqlite
  , sqliteIO
  , sqliteConn
  , module SQLite
  ) where

import Control.NatTrans
import Control.Monad.Reader
import Data.Int (Int64)
import qualified Database.SQLite.Simple         as SQLite
import qualified Database.SQLite.Simple.FromRow as SQLite

newtype ID a = ID { _unID :: Int64 }
  deriving (Eq, Show)

newtype SQLite a = SQLite { unSQL :: ReaderT SQLite.Connection IO a }
  deriving (Functor, Applicative, Monad, MonadReader SQLite.Connection)

sqlite :: String -> IO (NatTrans SQLite IO)
sqlite dbname = do
  conn <- SQLite.open dbname
  return (NT ((`runReaderT` conn) . unSQL))

sqliteIO :: IO a -> SQLite a
sqliteIO = SQLite . liftIO

-- FIXME: Hide away the SQLite imeplemetation
sqliteConn :: SQLite SQLite.Connection
sqliteConn = ask
