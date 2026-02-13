## 更新日誌說明
**SessTest.jsp**和**SessGet**是用來測試Session功能的，需要開不同瀏覽器分別開啟查看
**applicationTest.jsp**和**applicationGet.jsp**同理 (詳情請了解JSP四大作用域以便更深理解)

然後是透過Session實作登入系統，並且利用Session判斷是否得到Session而有沒有進入Friend_List.jsp內

資料庫需要確認有以下表格
```sql
CREATE TABLE Friend.dbo.Org (
	OrgId int IDENTITY(1,1) NOT NULL,
	OrgName nvarchar(50) COLLATE Chinese_Taiwan_Stroke_CI_AS DEFAULT '' NOT NULL,
	ID nvarchar(50) COLLATE Chinese_Taiwan_Stroke_CI_AS DEFAULT '' NOT NULL,
	PWD nvarchar(50) COLLATE Chinese_Taiwan_Stroke_CI_AS DEFAULT '' NOT NULL,
	isEnable int DEFAULT 0 NOT NULL,
	CONSTRAINT PK_Org PRIMARY KEY (OrgId)
);
```

```sql
CREATE TABLE Friend.dbo.Friend_Ques (
	Q_RecId int IDENTITY(1,1) NOT NULL,
	Q_Subject nvarchar(255) COLLATE Chinese_Taiwan_Stroke_CI_AS DEFAULT '' NOT NULL,
	Q_Content nvarchar(4000) COLLATE Chinese_Taiwan_Stroke_CI_AS DEFAULT '' NOT NULL,
	Q_RecDate datetime DEFAULT getdate() NOT NULL,
	Q_FRecId int DEFAULT 0 NOT NULL,
	CONSTRAINT PK_Friend_Ques PRIMARY KEY (Q_RecId)
);
```

最後實作是抓取在Friend_List.jsp中抓取興趣並顯示，使用的是HashMap物件，這是一個鍵值對Object，可以先去了解運作原理

