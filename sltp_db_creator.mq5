#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs "true"

//файлы баз данных создаются в ...\AppData\Roaming\MetaQuotes\Terminal\Common\Files
input string dbName = "trades.db";     //имя БД
input string fileName = "trades.csv";  //имя файла

void OnStart()
{
   
   int db = DatabaseOpen( dbName, DATABASE_OPEN_READWRITE | DATABASE_OPEN_CREATE | DATABASE_OPEN_COMMON );
   
   if( DatabaseTableExists( db, "TRADEHISTORY" ) )
   {
      DatabaseExecute( db, "DROP TABLE TRADEHISTORY;" );     
   }
   
   DatabaseExecute( db, "CREATE TABLE TRADEHISTORY( TIME INT NOT NULL, TYPE TEXT );" ); 
   
   //файлы из директории ...\MQL5\Files
   int file = FileOpen( fileName, FILE_READ | FILE_BIN | FILE_ANSI | FILE_CSV );
   
   while( ! FileIsEnding( file ) )
   {
      string time = FileReadString( file );
      string type = FileReadString( file );
      
      string request = StringFormat( "INSERT INTO TRADEHISTORY ( TIME, TYPE ) VALUES ( %d, '%s' );", int( StringToTime( time ) ), type );
      DatabaseExecute( db, request );     
   }

   FileClose( file );    
   DatabaseClose( db );
}