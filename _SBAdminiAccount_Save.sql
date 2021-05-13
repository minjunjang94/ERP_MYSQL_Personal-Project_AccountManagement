drop PROCEDURE _SBAdminiAccount_Save;

DELIMITER $$
CREATE PROCEDURE _SBAdminiAccount_Save
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
    DECLARE Var_AccSeq				INT;
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
    -- Insert --
	IF( InData_OperateFlag = 'S' ) THEN
		INSERT INTO _TCBaseAccount 
		( 	 
			 CompanySeq				-- 법인내부코드
			,AccNo					-- 계정코드
			,AccName				-- 계정과목
			,DrOrCr					-- 차대구분
			,IsAnti					-- 차감계정여부
			,IsSlip					-- 전표기표여부
			,UpAccSeq				-- 상위계정내부코드
			,IsEssCostDept			-- 귀속부서필수여부
			,IsLevel2				-- 2레벨잔액여부
			,IsZeroAllow			-- 금액0허용여부
			,IsEssForAmt			-- 외화금액필수여부
			,IsEssEvid				-- 증빙필수여부
			,IsEssCost				-- 원가항목필수여부
			,IsUseRNP				-- 출납사용여부
			,RNPMethod				-- 출납방법
			,BgtType				-- 예산유형
			,IsCash					-- 현금성여부
			,IsFundSet				-- 자금승인여부
			,IsAutoExec				-- 자동출납집행여부
			,AccType				-- 계정구분
			,AccKind				-- 계정대분류
			,OffRemType				-- 건별반제
			,RemType				-- 관리구분
			,RemCode				-- 관리코드
			,AutoSetType			-- 자동승인처리여부
			,LastUserSeq			-- 작업자
			,LastDateTime			-- 작업일시
        )
		VALUES
		(
			 InData_CompanySeq		
			,InData_AccNo			
			,InData_AccName			
			,Var_DrOrCr			
			,InData_IsAnti			
			,InData_IsSlip			
			,InData_UpAccSeq		
			,InData_IsEssCostDept	
			,InData_IsLevel2		
			,InData_IsZeroAllow		
			,InData_IsEssForAmt		
			,InData_IsEssEvid		
			,InData_IsEssCost		
			,InData_IsUseRNP		
			,Var_RNPMethod		
			,Var_BgtType			
			,InData_IsCash			
			,InData_IsFundSet		
			,InData_IsAutoExec		
			,Var_AccType			
			,Var_AccKind			
			,Var_OffRemType		
			,Var_RemType			
			,Var_RemCode			
			,Var_AutoSetType		
			,Login_UserSeq			
			,Var_GetDateNow			
		);
        
        SELECT '저장이 완료되었습니다' AS Result;

	-- ---------------------------------------------------------------------------------------------------        
    -- Delete --
	ELSEIF ( InData_OperateFlag = 'D' ) THEN  
    
		SET Var_AccSeq = (SELECT A.AccSeq FROM _TCBaseAccount AS A WHERE A.CompanySeq = InData_CompanySeq AND A.AccNo = InData_AccNo AND A.AccName = InData_AccName);  
        
		DELETE FROM _TCBaseAccount AS A WHERE A.CompanySeq = InData_CompanySeq AND A.AccNo = InData_AccNo AND A.AccName = InData_AccName;

        SELECT '삭제되었습니다.' AS Result; 
        
	END IF;	
    
END $$
DELIMITER ;