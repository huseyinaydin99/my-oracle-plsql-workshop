CREATE OR REPLACE PROCEDURE PRINT(p_message IN VARCHAR2) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(p_message);
END;
/

--<< HATA OLURSA BUNU DENE
CREATE OR REPLACE PROCEDURE PRINT(P_MESSAGE VARCHAR2)
AUTHID CURRENT_USER
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(P_MESSAGE);
END;
/

"
Hata mesajı, Oracle PL/SQL'de bir modül (örneğin bir paket, prosedür veya fonksiyon) oluştururken veya tanımlarken AUTHID yantümcesinin atlandığını belirtir. Bu durumda, AUTHID yantümcesi belirtilmediğinde, varsayılan olarak DEFINER yetkisi kullanılır.

Anlamı:
AUTHID DEFINER: Bu, varsayılan davranıştır. Prosedür, fonksiyon veya paket tanımlayan kullanıcının yetkileriyle çalışır.
AUTHID CURRENT_USER: Bu, modülün çağrıldığı kullanıcının yetkileriyle çalışmasını sağlar. Yani, o anki kullanıcıya göre haklar belirlenir.
"
