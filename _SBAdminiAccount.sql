drop PROCEDURE _SBAdminiAccount;

DELIMITER $$
CREATE PROCEDURE _SBAdminiAccount
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
    
    DECLARE State INT;
    
    -- ---------------------------------------------------------------------------------------------------
    -- Check --
	call _SBAdminiAccount_Check
		(
			 InData_OperateFlag		
			,InData_CompanySeq		
			,InData_AccNo			
			,InData_AccName			
			,InData_DrOrCr			
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
			,InData_RNPMethodName		
			,InData_BgtTypeName			
			,InData_IsCash			
			,InData_IsFundSet		
			,InData_IsAutoExec		
			,InData_AccTypeName			
			,InData_AccKindName			
			,InData_OffRemTypeName		
			,InData_RemTypeName			
			,InData_RemCodeName			
			,InData_AutoSetTypeName		
			,Login_UserSeq				
			,@Error_Check
		);
    

	IF( @Error_Check = (SELECT 9999) ) THEN
		
        SET State = 9999; -- Error 발생
        
	ELSE

	    SET State = 1111; -- 정상작동
        
		-- ---------------------------------------------------------------------------------------------------
		-- Save --
		IF( (InData_OperateFlag = 'S' OR InData_OperateFlag = 'D') AND STATE = 1111 ) THEN
			call _SBAdminiAccount_Save
				(
					 InData_OperateFlag		
					,InData_CompanySeq		
					,InData_AccNo			
					,InData_AccName			
					,InData_DrOrCr			
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
					,InData_RNPMethodName		
					,InData_BgtTypeName			
					,InData_IsCash			
					,InData_IsFundSet		
					,InData_IsAutoExec		
					,InData_AccTypeName			
					,InData_AccKindName			
					,InData_OffRemTypeName		
					,InData_RemTypeName			
					,InData_RemCodeName			
					,InData_AutoSetTypeName		
					,Login_UserSeq					
				);
		END IF;	
    
		-- ---------------------------------------------------------------------------------------------------
		-- Update --
		IF( InData_OperateFlag = 'U' AND STATE = 1111 ) THEN
			call _SBAdminiAccount_Update
				(
					 InData_OperateFlag		
					,InData_CompanySeq		
					,InData_AccNo			
					,InData_AccName			
					,InData_DrOrCr			
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
					,InData_RNPMethodName		
					,InData_BgtTypeName			
					,InData_IsCash			
					,InData_IsFundSet		
					,InData_IsAutoExec		
					,InData_AccTypeName			
					,InData_AccKindName			
					,InData_OffRemTypeName		
					,InData_RemTypeName			
					,InData_RemCodeName			
					,InData_AutoSetTypeName		
					,Login_UserSeq					
				);		
		END IF;	    

	END IF;
END $$
DELIMITER ;