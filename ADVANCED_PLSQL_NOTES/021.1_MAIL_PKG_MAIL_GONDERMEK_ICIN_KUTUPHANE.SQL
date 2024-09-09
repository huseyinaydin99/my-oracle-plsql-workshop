create or replace 
PACKAGE MAIL_PKG AS
Procedure Mail_Gonder (P_From_Mail  Varchar2,  P_To_Mail Varchar2, P_Cc_Mail Varchar2, P_Subject Varchar2, 
                          P_Message Varchar2, P_Oracle_Directory Varchar2, P_Binary_File Varchar2, P_Smtp_Server Varchar2, P_Smtp_Server_Port Number,
                          P_smtp_username VARCHAR2, P_smtp_password VARCHAR2);
PROCEDURE mime_tip(p_conn  in out nocopy utl_smtp.connection,  p_name  in varchar2,   p_value in varchar2);
PROCEDURE sinir_belirle(p_conn IN OUT NOCOPY UTL_SMTP.CONNECTION,   p_last IN BOOLEAN DEFAULT false);
PROCEDURE eklentiyi_bitir(p_conn IN OUT NOCOPY UTL_SMTP.CONNECTION,  p_last IN BOOLEAN DEFAULT TRUE);
PROCEDURE eklentiye_basla(p_conn IN OUT NOCOPY UTL_SMTP.CONNECTION,   p_mime_type    IN VARCHAR2 DEFAULT 'text/plain',  p_inline       IN BOOLEAN DEFAULT false,
                           p_filename     IN VARCHAR2 DEFAULT null,   p_transfer_enc IN VARCHAR2 DEFAULT null);
Procedure Binary_Eklenti(P_Conn In Out NOCOPY Utl_Smtp.Connection,   P_File_Name In Varchar2,   P_Mime_Type In Varchar2, P_Oracle_Directory In Varchar2);
End Mail_Pkg;
/
create or replace 
PACKAGE BODY MAIL_PKG AS
Procedure Mail_Gonder (P_From_Mail  Varchar2,  P_To_Mail Varchar2, P_Cc_Mail Varchar2, P_Subject Varchar2, 
P_Message Varchar2, P_Oracle_Directory Varchar2, P_Binary_File Varchar2, P_Smtp_Server Varchar2, P_Smtp_Server_Port Number,
P_smtp_username VARCHAR2, P_smtp_password VARCHAR2) IS
/*********************************************************************************

*********************************************************************************/
/* Change the SMTP_SERVER_NAME and PORT number according to your environment */
Wv_Smtp_Server      Varchar2(100)       := P_Smtp_Server;
wv_smtp_server_port NUMBER             := P_Smtp_Server_Port;
wv_smtp_username    VARCHAR2(100) := P_smtp_username;
wv_smtp_password    VARCHAR2(100) := P_smtp_password;
wv_Encoded_Username varchar2(2048);
wv_Encoded_Password varchar2(2048);

wv_directory_name   VARCHAR2(100) := P_Oracle_Directory;
wv_file_name        VARCHAR2(100);
wv_mesg             VARCHAR2(32767);
wv_conn             UTL_SMTP.CONNECTION;

-- �alistirmak i�in
-- set serveroutput on
--exec MAIL_PKG.mail_gonder('<from_email_id>', '<to_email_id>', '<cc_mail>','<subject_line>', 'message_body', '<directory_name>', '<file_name_to_be_attached>',
-- <Smtp_Server>, <Smtp_Server_Port>, <smtp_username> , <smtp_password> );
-- �rnek
-- 
/*** MAIN Routine ***/
BEGIN
    wv_Encoded_Username := UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw(wv_smtp_username)));
    wv_Encoded_Password := UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw(wv_smtp_password)));
 
    wv_conn:= UTL_SMTP.OPEN_CONNECTION( wv_smtp_server, wv_smtp_server_port);
  -- UTL_SMTP.HELO( wv_conn, wv_smtp_server );
    UTL_SMTP.ehlo(wv_conn, wv_smtp_server);
  
    UTL_SMTP.command(wv_conn, 'AUTH', 'LOGIN');
    UTL_SMTP.command(wv_conn, wv_Encoded_Username);
    UTL_SMTP.command(wv_conn, wv_Encoded_Password);
  
   UTL_SMTP.MAIL( wv_conn, p_from_mail);
   UTL_SMTP.RCPT( wv_conn, p_to_mail);
   IF p_cc_mail is not null then
           UTL_SMTP.RCPT( wv_conn, p_cc_mail);
    END IF;
   UTL_SMTP.OPEN_DATA ( wv_conn );
   -- UTL_SMTP.WRITE_DATA(wv_conn, 'Subject: '||p_subject||UTL_TCP.CRLF);
   UTL_SMTP.write_data(wv_conn, 'Subject: '|| ' =?iso-8859-9?Q?'|| UTL_RAW.cast_to_varchar2
   (UTL_ENCODE.quoted_printable_encode(UTL_RAW.cast_to_raw (p_subject)))||'?='||UTL_TCP.CRLF);
   
   wv_mesg:= 'Content-Transfer-Encoding: 7bit' || UTL_TCP.CRLF ||
   'Content-Type: multipart/mixed;boundary="DMW.Boundary.605592468"' || UTL_TCP.CRLF ||
   'Mime-Version: 1.0' || UTL_TCP.CRLF ||
   '--DMW.Boundary.605592468' || UTL_TCP.CRLF ||
   'Content-Transfer-Encoding: binary'||UTL_TCP.CRLF||
   'Content-Type: text/plain' ||UTL_TCP.CRLF ||
   UTL_TCP.CRLF || p_message || UTL_TCP.CRLF ;
   
   UTL_SMTP.write_data(wv_conn, 'To: ' || p_to_mail || UTL_TCP.crlf);
   IF p_cc_mail is not null then
       UTL_SMTP.write_data(wv_conn, 'Cc: ' || p_cc_mail || UTL_TCP.crlf);
   END IF;
   UTL_SMTP.WRITE_RAW_DATA ( wv_conn, UTL_RAW.CAST_TO_RAW(wv_mesg) );
   /*** Attachment burada ** MC*/
 --  binary_eklenti(p_conn IN OUT UTL_SMTP.CONNECTION, p_file_name IN VARCHAR2, p_mime_type in VARCHAR2, p_oracle_directory IN VARCHAR2)
   Binary_Eklenti(P_Conn => Wv_Conn, P_File_Name => P_Binary_File, 
                     -- mime Type Belirle.
                     p_mime_type => 'text/pdf; name="'||p_binary_file||'"', p_oracle_directory => p_oracle_directory);
   /*** Send E-Mail ***/
   UTL_SMTP.CLOSE_DATA( wv_conn );
   UTL_SMTP.QUIT( wv_conn );
END mail_gonder ;

PROCEDURE mime_tip(p_conn  in out nocopy utl_smtp.connection,   p_name  in varchar2,  p_value in varchar2) IS
BEGIN
   UTL_SMTP.WRITE_RAW_DATA(
   p_conn,
   UTL_RAW.CAST_TO_RAW( p_name || ': ' || p_value || UTL_TCP.CRLF)
   );
END mime_tip;

PROCEDURE sinir_belirle(p_conn IN OUT NOCOPY UTL_SMTP.CONNECTION,  p_last IN BOOLEAN DEFAULT false) IS
BEGIN
  IF (p_last) THEN
    UTL_SMTP.WRITE_DATA(p_conn, '--DMW.Boundary.605592468--'||UTL_TCP.CRLF);
  ELSE
    UTL_SMTP.WRITE_DATA(p_conn, '--DMW.Boundary.605592468'||UTL_TCP.CRLF);
  END IF;
END sinir_belirle;
PROCEDURE eklentiyi_bitir(p_conn IN OUT NOCOPY UTL_SMTP.CONNECTION,  p_last IN BOOLEAN DEFAULT TRUE) IS
BEGIN
   UTL_SMTP.WRITE_DATA(p_conn, UTL_TCP.CRLF);
   IF (p_last) THEN
    sinir_belirle(p_conn, p_last);
   END IF;
END eklentiyi_bitir;

Procedure Eklentiye_Basla(P_Conn  In Out Nocopy Utl_Smtp.Connection,  P_Mime_Type    In Varchar2 Default 'text/plain',  
            p_inline  IN BOOLEAN DEFAULT false, 
             p_filename     IN VARCHAR2 DEFAULT null,  p_transfer_enc IN VARCHAR2 DEFAULT null) IS
BEGIN
   sinir_belirle(p_conn);
   IF (p_transfer_enc IS NOT NULL) THEN
     mime_tip(p_conn, 'Content-Transfer-Encoding',p_transfer_enc);
   END IF;
   mime_tip(p_conn, 'Content-Type', p_mime_type);
   IF (p_filename IS NOT NULL) THEN
      IF (p_inline) THEN
         mime_tip(p_conn,'Content-Disposition', 'inline; filename="' || p_filename || '"');
      ELSE 
         mime_tip(p_conn,'Content-Disposition', 'attachment; filename="' || p_filename || '"');
      END IF;
   END IF;
   UTL_SMTP.WRITE_DATA(p_conn, UTL_TCP.CRLF);
END eklentiye_basla;

PROCEDURE binary_eklenti(p_conn IN OUT NOCOPY UTL_SMTP.CONNECTION, p_file_name IN VARCHAR2, p_mime_type in VARCHAR2, p_oracle_directory IN VARCHAR2) IS
C_Max_Line_Width Constant Pls_Integer Default 54;
wv_amt            BINARY_INTEGER := 672 * 3; /*Format De�eri; 2016 */
wv_bfile          BFILE;
wv_file_length    PLS_INTEGER;
wv_buf            RAW(2100);
wv_modulo         PLS_INTEGER;
wv_pieces         PLS_INTEGER;
wv_file_pos       pls_integer := 1;
BEGIN
  eklentiye_basla(p_conn => p_conn, p_mime_type => p_mime_type, p_inline => TRUE, p_filename => p_file_name,  p_transfer_enc => 'base64');
  BEGIN
     Wv_Bfile := Bfilename(P_Oracle_Directory, P_File_Name);
     -- Eklenecek Dosyan�n Size bul
     Wv_File_Length := Dbms_Lob.Getlength(Wv_Bfile);
     -- Dosya Ka� par�adan olu�uyor, hesapla
     Wv_Pieces := Trunc(Wv_File_Length / Wv_Amt);
     -- Hesaplamadan sonra art�k par�a var m?
     wv_modulo := MOD(wv_file_length, wv_amt);
     If (Wv_Modulo <> 0) Then
       -- Tam B�lme i�lemi ger�ekle�mediyse par�a say�s�n� 1 art�r.
       wv_pieces := wv_pieces + 1;
     END IF;
     DBMS_LOB.FILEOPEN(wv_bfile, DBMS_LOB.FILE_READONLY);
 
     For I In 1 .. Wv_Pieces Loop
       -- Par�a say�s�nca d�nd�r (Oku)
       wv_buf := NULL;
       DBMS_LOB.READ(wv_bfile, wv_amt, wv_file_pos, wv_buf);
       wv_file_pos := I * wv_amt + 1;
       UTL_SMTP.WRITE_RAW_DATA(p_conn, UTL_ENCODE.BASE64_ENCODE(wv_buf));
     END LOOP;
   END;
   DBMS_LOB.FILECLOSE(wv_bfile);
   eklentiyi_bitir(p_conn => p_conn);
EXCEPTION
WHEN NO_DATA_FOUND THEN
    eklentiyi_bitir(p_conn => p_conn);
    DBMS_LOB.FILECLOSE(wv_bfile);
End Binary_Eklenti;
END MAIL_PKG;
/
