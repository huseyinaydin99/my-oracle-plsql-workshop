DECLARE

BEGIN
    AS_XLSX.QUERY2SHEET(
        'SELECT *
        FROM EMP'
    );
    AS_XLSX.SAVE('EXCEL_DIR', 'DENEME1.XLSX');
END;

BEGIN
    AS_XLSX.SHEET('CALISAN');
    AS_XLSX.QUERYSHEET('
        SELECT *
        FROM EMP
    ',
    P_SHEET => 1);

    AS_XLSX.SHEET('DEPARTMAN');
    AS_XLSX.QUERYSHEET('
        SELECT *
        FROM DEPT
    ',
    P_SHEET => 2);

    AS_XLSX.SAVE('EXCEL_DIR', 'DENEME2.XLSX');
END;