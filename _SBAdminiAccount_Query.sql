drop PROCEDURE _SBAdminiAccount_Query;

DELIMITER $$
CREATE PROCEDURE _SBAdminiAccount_Query
	(
		 InData_CompanySeq			INT				-- 법인내부코드
		,InData_AccNo				VARCHAR(100)	-- 계정코드
		,InData_AccName				VARCHAR(100)    -- 계정과목
		,InData_DrOrCr				VARCHAR(20)     -- 차대구분
		,Login_UserSeq				INT				-- 현재 로그인 중인 유저
    )
BEGIN    

	IF (InData_AccNo 		IS NULL OR InData_AccNo 	LIKE ''	) THEN	SET InData_AccNo 		= '%'; END IF;
 	IF (InData_AccName 		IS NULL OR InData_AccName 	LIKE ''	) THEN	SET InData_AccName 		= '%'; END IF;
 	IF (InData_DrOrCr 		IS NULL OR InData_DrOrCr 	LIKE ''	) THEN	SET InData_DrOrCr 		= '%'; END IF;
    
    -- ---------------------------------------------------------------------------------------------------
    -- Query --
    
    set session transaction isolation level read uncommitted; 
    -- 최종조회 --
    SELECT 
		 A.CompanySeq			AS CompanySeq			
		,A.AccSeq				AS AccSeq				
		,A.AccNo				AS AccNo				
		,A.AccName				AS AccName		
		,B.MinorName			AS DrOrCrName
		,B.MinorSeq				AS DrOrCr	
		,A.IsAnti				AS IsAnti				
		,A.IsSlip				AS IsSlip				
		,A.IsEssCostDept		AS IsEssCostDept		
		,A.IsLevel2				AS IsLevel2			
		,A.IsZeroAllow			AS IsZeroAllow		
		,A.IsEssForAmt			AS IsEssForAmt		
		,A.IsEssEvid			AS IsEssEvid			
		,A.IsEssCost			AS IsEssCost			
		,A.IsUseRNP				AS IsUseRNP			
		,C.MinorName			AS RNPMethodName		
		,C.MinorSeq				AS RNPMethod			
		,D.MinorName			AS BgtTypeName		
		,D.MinorSeq				AS BgtType			
		,A.IsCash				AS IsCash				
		,A.IsFundSet			AS IsFundSet			
		,A.IsAutoExec			AS IsAutoExec			
		,E.MinorName			AS AccTypeName		
		,E.MinorSeq				AS AccType			
		,F.MinorName			AS AccKindName		
		,F.MinorSeq				AS AccKind			
		,G.MinorName			AS OffRemTypeName		
		,G.MinorSeq				AS OffRemType			
		,H.MinorName			AS RemTypeName		
		,H.MinorSeq				AS RemType			
		,I.MinorName			AS RemCodeName		
		,I.MinorSeq				AS RemCode			
		,J.MinorName			AS AutoSetTypeName	
		,J.MinorSeq				AS AutoSetType		
		,K.UserName				AS LastUserName		
		,K.UserSeq				AS LastUserSeq		
		,A.LastDateTime			AS LastDateTime		
	FROM _TCBaseAccount 			AS A
    LEFT OUTER JOIN _TCBaseMinor	AS B	 ON B.CompanySeq 	= A.CompanySeq
											AND B.MinorSeq   	= A.DrOrCr		
    LEFT OUTER JOIN _TCBaseMinor	AS C	 ON C.CompanySeq 	= A.CompanySeq
											AND C.MinorSeq   	= A.RNPMethod		
    LEFT OUTER JOIN _TCBaseMinor	AS D	 ON D.CompanySeq 	= A.CompanySeq
											AND D.MinorSeq   	= A.BgtType		
    LEFT OUTER JOIN _TCBaseMinor	AS E	 ON E.CompanySeq 	= A.CompanySeq
											AND E.MinorSeq   	= A.AccType		
    LEFT OUTER JOIN _TCBaseMinor	AS F	 ON F.CompanySeq 	= A.CompanySeq
											AND F.MinorSeq   	= A.AccKind		
    LEFT OUTER JOIN _TSBaseMinor	AS G	 ON G.CompanySeq 	= A.CompanySeq
											AND G.MinorSeq   	= A.OffRemType		
    LEFT OUTER JOIN _TSBaseMinor	AS H	 ON H.CompanySeq 	= A.CompanySeq
											AND H.MinorSeq   	= A.RemType		
    LEFT OUTER JOIN _TSBaseMinor	AS I	 ON I.CompanySeq 	= A.CompanySeq
											AND I.MinorSeq   	= A.RemCode		
    LEFT OUTER JOIN _TSBaseMinor	AS J	 ON J.CompanySeq 	= A.CompanySeq
											AND J.MinorSeq   	= A.AutoSetType		
	LEFT OUTER JOIN _TCBaseUser		AS K     ON K.CompanySeq 	= A.CompanySeq
										    AND K.UserSeq	    = A.LastUserSeq
    WHERE A.CompanySeq    			=    InData_CompanySeq
      AND A.AccNo 					LIKE InData_AccNo
      AND A.AccName					LIKE InData_AccName
      AND A.DrOrCr					LIKE InData_DrOrCr;
      
	set session transaction isolation level repeatable read;

END $$
DELIMITER ;