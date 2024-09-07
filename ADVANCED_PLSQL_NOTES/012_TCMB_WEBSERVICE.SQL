-- WEB ADRES
-- https://www.tcmb.gov.tr/kurlar/today.xml

CREATE TABLE GUNLUKKUR(
    TARIH DATE,
    KOD VARCHAR2(4),
    ALIS NUMBER(16, 4),
    SATIS NUMBER(16, 4),
    EFALIS NUMBER(16, 4),
    EFSATIS NUMBER(16, 4)
);

DROP TABLE GUNLUKKUR;

DESC GUNLUKKUR;

DROP PROCEDURE WSL_GET_KURLAR;

-- ALINACAK SEY KENDI ETIKETIN ICERISINDEYSE @(EMPERSANT) ISARETI KULLANILIR.

EXEC WSL_GET_KURLAR;

CREATE OR REPLACE
PROCEDURE WSL_GET_KURLAR
IS
    TCMB_URL HTTPURITYPE;
    TCMB_XML XMLTYPE;
BEGIN
    TCMB_URL := HTTPURITYPE.CREATEURI('http://www.tcmb.gov.tr/kurlar/today.xml');
    TCMB_XML := TCMB_URL.GETXML();
    
    FOR OKU IN (
        SELECT EXTRACTVALUE(VALUE(X), '/Tarih_Date/@Tarih') WTARIH,
               EXTRACTVALUE(VALUE(P), '/Currency/@CurrencyCode') WKOD,
               EXTRACTVALUE(VALUE(P), '/Currency/ForexBuying/') WALIS,
               EXTRACTVALUE(VALUE(P), '/Currency/ForexSelling') WSATIS,
               EXTRACTVALUE(VALUE(P), '/Currency/BanknoteBuying') WEFALIS,
               EXTRACTVALUE(VALUE(P), '/Currency/BanknoteSelling') WEFSATIS
    FROM
        TABLE(XMLSEQUENCE(
            EXTRACT(
                TCMB_XML,
                'Tarih_Date'
            )
        )) X,
        TABLE(
            XMLSEQUENCE(
                EXTRACT(
                    VALUE(X),
                    'Tarih_Date/Currency'
                )
            )
        ) P
        WHERE EXTRACTVALUE(
            VALUE(P),
             '/Currency/@CurrencyCode'
             )
             IN('USD','EUR')
    )
         LOOP
            INSERT
            INTO GUNLUKKUR(
                TARIH,
                KOD,
                ALIS,
                SATIS,
                EFALIS,
                EFSATIS
            )
            SELECT TO_DATE(OKU.WTARIH, 'DD/MM/YYYY'),
                   OKU.WKOD,
                   REPLACE(OKU.WALIS, '.', ','),
                   REPLACE(OKU.WSATIS, '.', ','),
                   REPLACE(OKU.WEFALIS, '.', ','),
                   REPLACE(OKU.WEFSATIS, '.', ',')
            FROM DUAL;
            COMMIT;
         END LOOP;
END WSL_GET_KURLAR;
-- BU PROCEDURE HATALIYSA ASAGIDAKINI CALISTIR




CREATE OR REPLACE
PROCEDURE WSL_GET_KURLAR
IS
    TCMB_url HTTPURITYPE;
    TCMB_xml XMLTYPE;
BEGIN
    TCMB_url := httpuritype.createuri('http://www.tcmb.gov.tr/kurlar/today.xml');
    TCMB_xml := TCMB_url.getxml();
    FOR OKU IN (SELECT EXTRACTVALUE(VALUE(X), '/Tarih_Date/@Tarih') Tarih,
                       EXTRACTVALUE(VALUE(P), '/Currency/@CurrencyCode') Kod,
                       EXTRACTVALUE(VALUE(P), '/Currency/ForexBuying') Alis,
                       EXTRACTVALUE(VALUE(P), '/Currency/ForexSelling') Satis,
                       EXTRACTVALUE(VALUE(P), '/Currency/BanknoteBuying') Efalis,
                       EXTRACTVALUE(VALUE(P), '/Currency/BanknoteSelling') Efsatis
                FROM
                    TABLE(XMLSEQUENCE(
                        EXTRACT(
                            TCMB_xml,
                        '/Tarih_Date'
                        ))
                    ) X,
                    TABLE(XMLSEQUENCE(
                        EXTRACT(
                            VALUE (X),
                            '/Tarih_Date/Currency'
                        ))
                    ) P
                WHERE EXTRACTVALUE(
                    VALUE(P),
                    '/Currency/@CurrencyCode')
                    IN ('USD', 'EUR')
                )
    LOOP
        INSERT
        INTO GUNLUKKUR(
            TARIH,
            KOD,
            ALIS,
            SATIS,
            EFALIS,
            EFSATIS
        )
        SELECT TRUNC(SYSDATE),
               TO_CHAR (OKU.KOD),
               NVL(REPLACE(OKU.ALIS, '.', ','), 0),
               NVL(REPLACE (OKU.SATIS, '.', ','), 0),
               NVL(REPLACE(OKU.EFALIS, '.', ','), 0), 
               NVL (REPLACE (OKU.EFSATIS, '.', ','), 0)
        FROM DUAL;
        COMMIT;
    END LOOP;
END WSL_GET_KURLAR;
