drop PROCEDURE _SBAdminiAccount_Update;

DELIMITER $$
CREATE PROCEDURE _SBAdminiAccount_Update
	(
		 InData_OperateFlag				CHAR(2)			-- 작업표시
		,InData_CompanySeq				INT				-- 법인내부코드
		,InData_AccNo					VARCHAR(20)		-- 계정코드
		,InData_AccName					VARCHAR(100)	-- 계정과목
		,InData_DrOrCr					VARCHAR(20)		-- 차대구분
		,InData_IsAnti					CHAR(1)			-- 차감계정여부
		,InData_IsSlip					CHAR(1)			-- 전표기표여부
        ,InData_UpAccSeq				INT				-- 상위계정내부코드
		,InData_IsEssCostDept			CHAR(1)			-- 귀속부서필수여부
		,InData_IsLevel2				CHAR(1)			-- 2레벨잔액여부
		,InData_IsZeroAllow				CHAR(1)			-- 금액0허용여부
		,InData_IsEssForAmt				CHAR(1)			-- 외화금액필수여부
		,InData_IsEssEvid				CHAR(1)			-- 증빙필수여부
		,InData_IsEssCost				CHAR(1)			-- 원가항목필수여부
		,InData_IsUseRNP				CHAR(1)			-- 출납사용여부
		,InData_RNPMethodName			VARCHAR(100)	-- 출납방법
		,InData_BgtTypeName				VARCHAR(100)	-- 예산유형
		,InData_IsCash					CHAR(1)			-- 현금성여부
		,InData_IsFundSet				CHAR(1)			-- 자금승인여부
		,InData_IsAutoExec				CHAR(1)			-- 자동출납집행여부
		,InData_AccTypeName				VARCHAR(100)	-- 계정구분
		,InData_AccKindName				VARCHAR(100)	-- 계정대분류
		,InData_OffRemTypeName			VARCHAR(100)	-- 건별반제
		,InData_RemTypeName				VARCHAR(100)	-- 관리구분
		,InData_RemCodeName				VARCHAR(100)	-- 관리코드
		,InData_AutoSetTypeName			VARCHAR(100)	-- 자동승인처리여부
		,Login_UserSeq					INT				-- 현재 로그인 중인 유저
    )
BEGIN

	-- 변수선언
    DECLARE Var_AccSeq 				INT;   
    DECLARE Var_GetDateNow			VARCHAR(100);
    DECLARE Var_RNPMethod			INT;
	DECLARE Var_BgtType				INT;
	DECLARE Var_AccType				INT;
	DECLARE Var_AccKind				INT;
	DECLARE Var_OffRemType			INT;
	DECLARE Var_RemType				INT;
	DECLARE Var_RemCode				INT;
	DECLARE Var_AutoSetType			INT;	
    DECLARE Var_DrOrCr				INT;

	SET Var_AccSeq 				= (SELECT A.AccSeq FROM _TCBaseAccount AS A WHERE A.CompanySeq = InData_CompanySeq AND A.AccNo = InData_AccNo AND A.AccName = InData_AccName);             
	SET Var_GetDateNow  		= (SELECT DATE_FORMAT(NOW(), "%Y-%m-%d %H:%i:%s") AS GetDate); -- 작업일시는 Save되는 시점의 일시를 Insert
	SET Var_RNPMethod			= (SELECT A.MinorSeq FROM _TCBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MinorName = InData_RNPMethodName	AND MajorSeq = 3002 );	 -- 출납방법			 _TCBaseMajor(3002)  : 카드종류	
    SET Var_BgtType				= (SELECT A.MinorSeq FROM _TCBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MinorName = InData_BgtTypeName		AND MajorSeq = 2002 );	 -- 예산유형			 _TCBaseMajor(2002)  : 예산유형	
    SET Var_AccType				= (SELECT A.MinorSeq FROM _TCBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MinorName = InData_AccTypeName		AND MajorSeq = 2003 );	 -- 계정구분			 _TCBaseMajor(2003)  : 전표종류그룹	
    SET Var_AccKind				= (SELECT A.MinorSeq FROM _TCBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MinorName = InData_AccKindName		AND MajorSeq = 2004 );	 -- 계정대분류		 	 _TCBaseMajor(2004)  : 재무제표분석항목분류
    SET Var_OffRemType			= (SELECT A.MinorSeq FROM _TSBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MinorName = InData_OffRemTypeName	AND MajorSeq = 20004);	 -- 건별반제			 _TSBaseMajor(20004) : 건별반제	
    SET Var_RemType				= (SELECT A.MinorSeq FROM _TSBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MinorName = InData_RemTypeName		AND MajorSeq = 20001);	 -- 관리구분			 _TSBaseMajor(20001) : 관리구분	
    SET Var_RemCode				= (SELECT A.MinorSeq FROM _TSBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MinorName = InData_RemCodeName		AND MajorSeq = 20002);	 -- 관리코드			 _TSBaseMajor(20002) : 관리코드	
    SET Var_AutoSetType			= (SELECT A.MinorSeq FROM _TSBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MinorName = InData_AutoSetTypeName	AND MajorSeq = 20003);	 -- 자동승인처리여부	 	 _TSBaseMajor(20003) : 자동승인처리	
	SET Var_DrOrCr				= (SELECT A.MinorSeq FROM _TCBaseMinor AS A WHERE A.CompanySeq = InData_CompanySeq AND A.MinorName = InData_DrOrCr      	AND MajorSeq = 2001 );	 -- 차대구분			 _TCBaseMajor(2001)  : 차대구분	
    

    -- ---------------------------------------------------------------------------------------------------
    -- Update --
	IF( InData_OperateFlag = 'U' ) THEN     
			UPDATE _TCBaseAccount		AS A
			   SET   A.DrOrCr			= Var_DrOrCr				
					,A.IsAnti			= InData_IsAnti				
					,A.IsSlip			= InData_IsSlip				
					,A.UpAccSeq			= InData_UpAccSeq			
					,A.IsEssCostDept	= InData_IsEssCostDept		
					,A.IsLevel2			= InData_IsLevel2			
					,A.IsZeroAllow		= InData_IsZeroAllow			
					,A.IsEssForAmt		= InData_IsEssForAmt			
					,A.IsEssEvid		= InData_IsEssEvid			
					,A.IsEssCost		= InData_IsEssCost			
					,A.IsUseRNP			= InData_IsUseRNP			
					,A.RNPMethod		= Var_RNPMethod			
					,A.BgtType			= Var_BgtType				
					,A.IsCash			= InData_IsCash				
					,A.IsFundSet		= InData_IsFundSet			
					,A.IsAutoExec		= InData_IsAutoExec			
					,A.AccType			= Var_AccType				
					,A.AccKind			= Var_AccKind				
					,A.OffRemType		= Var_OffRemType			
					,A.RemType			= Var_RemType				
					,A.RemCode			= Var_RemCode				
					,A.AutoSetType		= Var_AutoSetType			
					,A.LastUserSeq		= Login_UserSeq				
					,A.LastDateTime		= Var_GetDateNow	        
			WHERE  A.AccSeq				= Var_AccSeq;
                     
              SELECT '저장되었습니다.' AS Result; 
                     
	ELSE
			  SELECT '저장이 완료되지 않았습니다.' AS Result;
	END IF;	


END $$
DELIMITER ;