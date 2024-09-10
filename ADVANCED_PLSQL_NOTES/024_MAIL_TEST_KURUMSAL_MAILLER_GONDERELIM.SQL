exec MAIL_PKG.mail_gonder('<from_email_id>', '<to_email_id>', '<cc_mail>','<subject_line>',
'message_body', '<directory_name>', '<file_name_to_be_attached>', <Smtp_Server>, <Smtp_Server_Port>,
<smtp_username> , <smtp_password> );

EXECUTE MAIL_PKG.mail_gonder(
    'falanfelan99@gmail.com',
    'filanfelan99@gmail.com',
    '987@gmail.com',
    'DENEMLER OLSUN CNM SEFAM OLSUN',
    'merhabalar cnm',
    'PDF_DIR',
    'deneme1.pdf',
    'mail.smtp2go.com',
    2525,
    'SERVISEMAILADRES@gmail.com',
    'SIFREYIGIRANEYY'
);