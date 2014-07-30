DECLARE @DBNames TABLE 
  ( 
     DBName VARCHAR(150) NOT NULL, 
     RCnt   INT 
  ); 

INSERT INTO @DBNames 
SELECT name, 
       ROW_NUMBER() 
         OVER ( 
           ORDER BY name) 
FROM   master.sys.databases 

DECLARE @row    INT, 
        @maxRow INT 

SELECT @row = 1, 
       @maxRow = MAX(RCnt) 
FROM   @DBNames 

DECLARE @DBName VARCHAR(150) 

WHILE( @row < @maxRow ) 
  BEGIN 
      SELECT @DBName = DBName 
      FROM   @DBNames 
      WHERE  RCnt = @row 

      DECLARE @SQL NVARCHAR(MAX) = '  SELECT  Name, ''' + @DBName 
        + ''' AS [DBName] FROM    ' 
        + QUOTENAME(@DBName) 
        + '.sys.tables WHERE Name LIKE ''%downloads%'''; 

      EXECUTE SP_EXECUTESQL @SQL 

      PRINT @SQL 

      SELECT @row = @row + 1 
  END 