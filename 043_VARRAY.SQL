DECLARE
  TYPE TAKIMLAR
  IS
  VARRAY(10)
  OF VARCHAR(30);

  TAKIM TAKIMLAR := TAKIMLAR('BJK', 'GS', 'TS', 'FB'); --<< NEWLENDI
BEGIN
    PRINT('2002');
    PRINT('____--____--____');

    FOR I IN 1..TAKIM.COUNT
    LOOP
      PRINT(I || '.' || TAKIM(I));
    END LOOP;
END;
