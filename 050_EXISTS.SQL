DECLARE
  TYPE NDT_TYPE
  IS TABLE OF CHAR(1);

  VAR1 NDT_TYPE := NDT_TYPE('P', 'L', '/', 'S', 'Q', 'L');
BEGIN
  FOR I IN 1..6
  LOOP
    IF VAR1.EXISTS(I) THEN
      PRINT('VAR1: ' || I || ' DEGER: ' || VAR1(I));
    ELSE
      PRINT(I || '. INDEX DE DEGER YOK');
    END IF;
  END LOOP;

  VAR1.DELETE(3);

  PRINT('');
  
  FOR I IN 1..6
  LOOP
    IF VAR1.EXISTS(I) THEN
      PRINT('VAR1: ' || I || ' DEGER: ' || VAR1(I));
    ELSE
      PRINT(I || '. INDEX DE DEGER YOK');
    END IF;
  END LOOP;
END;
