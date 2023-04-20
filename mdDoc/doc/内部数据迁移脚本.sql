-- 项目信息迁移脚本
INSERT INTO pms_project_info (
	id,
	project_code,
	project_name,
	project_desc,
	project_phase,
	STATUS,
	passed_time,
	passed_amount,
	senior_project_type,
	second_project_type,
	supervise_type,
	industry_type,
	sponsor_id,
	sponsor_name,
	project_managerA_id,
	province,
	city,
	pins_id,
	first_letter_time,
	first_issue_time,
	relate_trade_status,
	risk_type,
	create_time 
) SELECT
t.id abc,
t.project_code,
t.project_name,
t.proj_desc,
(
	CASE
			WHEN cstage_names = '尽调阶段' THEN
			'10' 
			WHEN cstage_names = '质控阶段' THEN
			'30' 
			WHEN cstage_names = '合规风控阶段' THEN
			'30'
			WHEN cstage_names = '评审会阶段' THEN
			'40' 
			WHEN cstage_names = '合同阶段' THEN
			'60' 
			WHEN cstage_names = '发行阶段' THEN
			'70'
			WHEN cstage_names = '已发行' THEN
			'70'
            WHEN cstage_names = '放款阶段' THEN
			'70'			
			WHEN cstage_names = '跟踪管理阶段' THEN
			'80' 
			WHEN cstage_names = '已放款' THEN
			'80'
			WHEN cstage_names = '已结束' THEN
			'90' 
		END 
		),
		(
		CASE
				
				WHEN t.`status` = 'pausing' THEN
				'2' 
				WHEN t.`status` = 'terminated' THEN
				'3' 
				WHEN t.`status` = 'archived' THEN
				'4' ELSE '1' 
			END 
			),
			( SELECT MAX( ph.passed_date ) FROM zzxypm.csci_project_passed_his ph WHERE abc = ph.project_id ),
			(
			SELECT
				SUM(
					IFNULL( p.zx_pass_amount, 0 ))+ SUM(
				IFNULL( p.tz_pass_amount, 0 )) 
			FROM
				zzxypm.csci_project_passed_his p 
			WHERE
				abc = p.project_id 
			),
			( CASE WHEN proTypeId = '1' THEN 'credit_project_type' WHEN proTypeId = '3' THEN 'invest_project_type' END ) AS proTypeId,
			(
			CASE
					WHEN proTypeId = '1' 
					AND sonProTypeId = '1' THEN
						'2' 
					WHEN proTypeId = '1' 
					AND sonProTypeId = '2' THEN
						'3' 
						WHEN proTypeId = '1' 
						AND sonProTypeId = '3' THEN
							'4' 
							WHEN proTypeId = '1' 
							AND sonProTypeId = '4' THEN
								'5' 
								WHEN proTypeId = '1' 
							    AND sonProTypeId = '5' THEN
								'6' 
								WHEN proTypeId = '1' 
							    AND sonProTypeId = '6' THEN
								'7' 
								WHEN proTypeId = '1' 
							    AND sonProTypeId = '7' THEN
								'8' 
								WHEN proTypeId = '1' 
							    AND sonProTypeId = '8' THEN
								'9' 
								WHEN proTypeId = '1' 
							    AND sonProTypeId = '9' THEN
								'10' 
								WHEN proTypeId = '1' 
							    AND sonProTypeId = '10' THEN
								'11'
								WHEN proTypeId = '1' 
							    AND sonProTypeId = '11' THEN
								'1' ELSE sonProTypeId 
								END 
								) AS sonProTypeId,
								( CASE WHEN t.industry_type = 0 THEN '1' WHEN t.industry_type = 1  THEN '2' WHEN t.industry_type = 2 THEN '3' WHEN t.industry_type = 3 THEN '4' END ),
								( CASE WHEN t.industry_type = 0 THEN '1' WHEN t.industry_type = 1  THEN '2' WHEN t.industry_type = 2 THEN '3' END ),
								dept_id,
								dept_name,
								chief,
								'',
								'',
								pins_id,
								(
								SELECT
									MAX( zc.provide_time ) 
								FROM
									zzxypm.csci_contract_signature cs,
									zzxypm.csci_zx_contract zc 
								WHERE
									cs.id = zc.id 
									AND abc = cs.project_id 
								),
								( SELECT MAX( pi.issue_date ) FROM zzxypm.csci_product_issue pi WHERE abc = pi.project_id ),
								( CASE WHEN t.is_related = 0 THEN '2' WHEN t.is_related = 1  THEN '1' END ),
								( CASE WHEN t.risk_type = 1  THEN '不良资产' WHEN t.risk_type = 2  THEN '城投' WHEN t.risk_type = 3 THEN '产业类' WHEN t.risk_type = 4 THEN '中小微' WHEN t.risk_type = 5 THEN '金融' WHEN t.risk_type = 6 THEN '消费金融' WHEN t.risk_type = 7 THEN '保本基金' WHEN t.risk_type = 8 THEN '其它' WHEN t.risk_type = 9 THEN '对内增信' WHEN t.risk_type = 10 THEN 'CDS' WHEN t.risk_type = 11 THEN 'ABS次级' END ),
								rec_gen_time
							FROM
								zzxypm.csci_base_project t WHERE proTypeId = '1' or proTypeId = '3';


-- 项目经理迁移脚本
INSERT INTO pms_project_member (
	project_id,
	project_code,
	member_type,
	member_id,
	member_name
) SELECT
t.id,
t.project_code,
'1',
chief,
( SELECT r.NAME FROM sys_user r WHERE chief = r.id )
FROM
	zzxypm.csci_base_project t;
	
-- 项目成员迁移脚本
INSERT INTO pms_project_member (
	project_id,
	project_code,
	member_type,
	member_id,
	member_name
) SELECT
t.project_id,
p.project_code,
'6',
t.member_id as memberId,
(SELECT r.NAME FROM sys_user r WHERE memberId = r.id)
FROM
	zzxypm.csci_project_member t LEFT JOIN zzxypm.csci_base_project p ON t.project_id = p.id where p.project_code IS NOT NULL and t.member_id != p.chief;
	
-- 项目发行主体迁移脚本
INSERT INTO pms_project_org ( project_id, project_code, company_id, company_name, risk_role_type ) SELECT
t.id,
t.project_code,
c.company_id,
c.customer_name,
'11' 
FROM
	zzxypm.csci_base_project t,
	zzxypm.csci_base_customer c 
WHERE
	t.customer_id = c.id  
	AND c.type = '1' ;

-- 更新主体角色脚本
UPDATE pms_project_org SET org_type = '1' WHERE risk_role_type = '11';


-- 项目风险缓释措施迁移脚本
ALTER TABLE `pms_project_risk_mitigants` 
MODIFY COLUMN `risk_explain` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '风险缓释措施说明' AFTER `risk_mitigants`;

INSERT INTO pms_project_risk_mitigants (project_id, project_code, risk_explain, practicable,risk_mitigants ) SELECT
t.project_id,
c.project_code,
t.measure_description,
t.implement_description ,
'7'
FROM
	zzxypm.csci_risk_release_measure t
	LEFT JOIN zzxypm.csci_base_project c ON t.project_id = c.id WHERE c.project_code is not null;
	

-- 项目过会信息迁移
INSERT INTO pms_conference_info (
	project_id,
	project_code,
	conference_batch,
	conference_time,
	conference_money,
	conference_type,
	conference_result,
	amount_type,
	zx_amount,
	zx_force_amount,
	tz_amount,
	tz_force_amount ,
	create_time
) SELECT
c.project_id pid,
( SELECT p.project_code FROM zzxypm.csci_base_project p WHERE pid = p.id ),
0,
passed_date,
IFNULL( c.zx_pass_amount, 0 )+IFNULL(c.tz_pass_amount,0),
(CASE
		 
		WHEN c.meeting_type = '1' THEN
		'1' 
		WHEN c.meeting_type = '2' THEN
		'4'
		WHEN c.meeting_type = '3' THEN
		'2' 
		WHEN c.meeting_type = '4' THEN
		'5' 
		WHEN c.meeting_type = '5' THEN
		'6' 
		ELSE '4'
	END ),
(CASE
		 
		WHEN c.result = '1' THEN
		'1' 
		WHEN c.result = '2' THEN
		'5'
		WHEN c.result = '3' THEN
		'3' 
	END ),
c.passed_type,
c.zx_pass_amount,
c.zx_check_amount,
c.tz_pass_amount,
c.tz_check_amount,
c.rec_gen_time
FROM
	zzxypm.csci_project_passed_his c WHERE c.passed_type is not null;

-- 增信项目过会信息迁移
INSERT INTO pms_conference_info (
	project_id,
	project_code,
	conference_batch,
	conference_time,
	conference_money,
	conference_type,
	conference_result,
	amount_type,
	zx_amount,
	zx_force_amount,
	tz_amount,
	tz_force_amount ,
	create_time
) SELECT
c.id,
p.project_code,
0,
p.passed_time,
IFNULL( c.zx_pass_amount, 0 )+IFNULL(c.tz_pass_amount,0),
'1',
'1',
(CASE
		 
		WHEN c.zx_pass_amount IS NULL AND c.tz_pass_amount IS NOT NULL THEN
		'2' 
		WHEN c.zx_pass_amount IS NOT NULL AND c.tz_pass_amount IS NULL THEN
		'1'
		WHEN c.zx_pass_amount IS NOT NULL AND c.tz_pass_amount IS NOT NULL THEN
		'3' 
	END ),
c.zx_pass_amount,
c.zx_check_amount,
c.tz_pass_amount,
c.tz_check_amount,
c.rec_gen_time
FROM
zzxypm.csci_zx_project c
LEFT JOIN zzxypm.csci_base_project p ON c.id = p.id 
WHERE
	( c.zx_pass_amount IS NOT NULL OR c.tz_pass_amount IS NOT NULL ) 
	AND c.id NOT IN ( SELECT i.project_id FROM pms_conference_info i );
	

-- 投资项目过会信息
INSERT INTO pms_conference_info (
project_id,
project_code,
conference_batch,
conference_time,
conference_money,
conference_type,
conference_result,
amount_type,
tz_amount,
tz_force_amount ,
create_time
) SELECT
c.id,
p.project_code,
0,
p.passed_time,
p.passed_amount,
'1',
'1',
'2',
p.passed_amount,
p.check_amount,
c.rec_gen_time
FROM
zzxypm.csci_tz_project c
LEFT JOIN zzxypm.csci_base_project p ON c.id = p.id 
WHERE
	p.passed_amount IS NOT NULL
	AND c.id NOT IN ( SELECT i.project_id FROM pms_conference_info i );

-- 更新项目首次过会时间
UPDATE pms_project_info p SET p.first_meeting_time = (select MIN(t.conference_time) from pms_conference_info t where t.project_code = p.project_code);


-- 人员迁移脚本
INSERT INTO sys_user ( id, account, `name`, `password`, salt, birthday, email, address, phone ) SELECT
m.MEMBER_ID,
u.USER_NAME,
m.MEMBER_NAME,
'5e62dede2ff6ac5c58e7e08b1a4cf6c8',
'mcw0!j838c',
m.MEMBER_BIRTHDAY,
m.MEMBER_EMAIL,
m.MEMBER_ADDRESS,
m.MEMBER_PHONE 
FROM
	zzxypm.l_user u
	LEFT JOIN zzxypm.l_member m ON u.MEMBER_ID = m.MEMBER_ID;
	
	
-- 角色迁移脚本
INSERT INTO sys_role ( id,`name`,role_desc ) SELECT
 r.ROLE_ID,
 r.ROLE_NAME,
 r.ROLE_DESC
FROM
	zzxypm.l_role r;

-- 用户角色迁移脚本
INSERT INTO sys_user_role ( user_id,role_id ) SELECT
 r.member_id,
 r.role_id
FROM
	zzxypm.l_member_role_rel r;	


-- 部门迁移脚本
INSERT INTO sys_dept ( id,num,parent_id,simple_name,full_name ) SELECT
 r.ORG_ID,
 r.ORG_NUM,
 r.SUPER_ID,
 r.ORG_NAME,
 r.ORG_NAME
FROM
	zzxypm.l_organization r;
	
-- 用户部门迁移脚本
INSERT INTO sys_user_dept ( user_id,dept_id,is_principal ) SELECT
r.MEMBER_ID,
r.ORG_ID,
'1'
FROM
	zzxypm.l_member_organization_rel r;

	
-- 为角色赋权限
INSERT INTO sys_role_resource ( resource_id, role_id ) SELECT
id,
214 
FROM
	sys_resource;
	

-- 项目文件迁移
INSERT INTO sys_attachment (id,project_id,business_type,business_id,file_id,file_name,remark,instance_id,uploader_id,uploader_name,file_path,create_time)
SELECT
    c.id,
	c.project_id,
(CASE
		 
		WHEN c.scene_type = 'contract' THEN
		'CONTRACT_SIGNATURE_FILE' 
		WHEN c.scene_type = 'issue' THEN
		'ISSUE_INFO_FILE' 
		WHEN c.scene_type = 'initiation' THEN
		'APPLICATION_FORM' 
		WHEN c.scene_type = 'deal_structure' THEN
		'APPLICATION_FORM' 
		WHEN c.scene_type = 'finance' THEN
		'APPLICATION_FORM' 
		WHEN c.scene_type = 'cont_thirdparty' THEN
		'OTHER_SUPPLY_FILE' 
		WHEN c.scene_type = 'track_report' THEN
		'TRACK_RECORD_FILE' 
		WHEN c.scene_type = 'risk_relief' THEN
		'APPLICATION_FORM'  
		WHEN c.scene_type = 'lbpm' THEN
		'PROCESS_FILE' 
		ELSE 'PROCESS_FILE' 
	END ),
c.ref_id,
c.file_id,
c.file_name AS fileName,
c.remark,
c.pinst_id AS pinstId,
c.uploader AS uploader,
( SELECT m.member_name FROM zzxypm.l_member m WHERE c.uploader = m.member_id ) ,
'',
c.rec_gen_time
FROM
	zzxypm.csci_attachment c
	WHERE c.file_name is not null ;
-- and c.id not in (SELECT d.atta_id from zzxypm.csci_process_document d);
	
-- 更新审批附件ID	
UPDATE sys_attachment t SET t.business_id = (SELECT pr.record_id FROM zzxypm.csci_process_document pr WHERE t.id = pr.atta_id) WHERE t.business_type != 'CONTRACT_SIGNATURE_FILE';
-- 处理其它类型附件
update sys_attachment a SET a.business_id = (SELECT c.signature_id FROM zzxypm.csci_base_contract c  WHERE a.business_id = c.id and c.contract_type = 4);
UPDATE sys_attachment t SET t.business_id = (SELECT pr.record_id FROM zzxypm.csci_process_document pr WHERE t.id = pr.atta_id) WHERE t.business_id is null ;

	
-- 用印信息迁移
ALTER TABLE `pms_contract_signature` 
MODIFY COLUMN `seal_title` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用印申请标题' AFTER `project_code`;
ALTER TABLE `zzxypm_uat`.`pms_contract_signature` 
MODIFY COLUMN `need_company_letter` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '是否需要公司出函（yes_or_no）' AFTER `need_company_capital`;

INSERT INTO pms_contract_signature ( id, project_id, project_code, seal_title, seal_code, seal_unit, seal_remark, creator_id, need_company_capital, need_company_letter, `status`, create_time,element_type,pins_id ) SELECT
s.id as sid,
s.project_id AS pid,
IFNULL(( SELECT p.project_code FROM zzxypm.csci_base_project p WHERE p.id = pid ),''),
s.title,
'',
o.ORG_ID,
(SELECT t.yy_desc FROM zzxypm.csci_base_contract t WHERE sid = t.signature_id LIMIT 1),
s.creator,
( CASE WHEN s.iscompanycapital = '1' THEN '1' ELSE '2' END ),
( CASE WHEN s.iscompanycapital = '0' THEN '2' ELSE s.iscompanyletter END ),
'',
s.rec_gen_time ,
'',
h.INS_ID
FROM
	zzxypm.csci_contract_signature s
	LEFT JOIN zzxypm.l_organization o ON s.seal_unit = o.org_name
	LEFT JOIN zzxypm.lmsp_lbpm_histinsprop h ON h.prop_value = s.id WHERE h.prop_key='contractId';

-- 更新合同状态
UPDATE pms_contract_signature s 
SET `status` = IFNULL((
	SELECT
		MAX((
			CASE
					
					WHEN c.`status` = '1' THEN
					'2' 
					WHEN c.`status` = '2' THEN
					'3' ELSE '0' 
				END 
				)) 
		FROM
			zzxypm.csci_base_contract c 
		WHERE
			s.id = c.signature_id 
		),'');

-- 更新合同要素
UPDATE pms_contract_signature SET element_type = CONCAT(element_type,'1') WHERE id IN (SELECT c.signature_id FROM zzxypm.csci_base_contract c WHERE c.id IN (SELECT z.id FROM zzxypm.csci_zx_contract z));
UPDATE pms_contract_signature SET element_type = CONCAT(element_type,',2') WHERE id IN (SELECT c.signature_id FROM zzxypm.csci_base_contract c WHERE c.id IN(SELECT c.id FROM zzxypm.csci_tz_contract c ));
UPDATE pms_contract_signature SET element_type = CONCAT(element_type,',3') WHERE id IN (SELECT c.signature_id FROM zzxypm.csci_base_contract c WHERE c.id IN(SELECT c.id FROM zzxypm.csci_gwfw_contract c )) ;
-- UPDATE pms_contract_signature SET element_type = CONCAT('['+element_type,',5]') WHERE id IN (SELECT c.signature_id FROM zzxypm.csci_base_contract c WHERE c.id IN(SELECT c.id FROM zzxypm.csci_gwfw_contract c )) ;
UPDATE pms_contract_signature SET element_type = '5' WHERE element_type = '';

	
-- 增信函合同迁移
ALTER TABLE `tf_rbms`.`pms_contract_credit` 
MODIFY COLUMN `charge_mode` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '收费方式' AFTER `charge_number_other`;
ALTER TABLE `tf_rbms`.`pms_contract_credit` 
MODIFY COLUMN `replay_plan` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '还本付息安排' AFTER `duty_cost_amount_unit`;
ALTER TABLE `tf_rbms`.`pms_contract_credit` 
MODIFY COLUMN `credit_contract_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '增信函名称' AFTER `seal_id`;
INSERT INTO pms_contract_credit (
	id,
	project_id,
	project_code,
	seal_id,
	company_id,
	company_name,
	credit_contract_name,
	credit_contract_code,
	credit_type,
	issue_deadline,
	issue_deadline_standard_unit,
	issue_deadline_time_unit,
	duty_cost,
	duty_cost_standard_unit,
	duty_cost_amount_unit,
	replay_plan,
	credit_rate,
	credit_rate_time_unit,
	credit_rate_standard_unit,
	charge_number,
	charge_number_other,
	charge_mode,
	break_remark,
	letter_time ,
	create_time
) SELECT
c.id,
s.project_id AS pid,
(
	SELECT
		p.project_code 
	FROM
		zzxypm.csci_base_project p 
	WHERE
		pid = p.id 
	),
	s.id,
	0,
	'',
	bc.contract_name,
	c.letter_code,
	c.zx_type,
	c.iduration,
	1,
	1,
	c.duty_amount,
	1,
	(CASE
		WHEN c.duty_amount_unit = 0 THEN
		3 
		WHEN c.duty_amount_unit = 1 THEN
		2
		WHEN c.duty_amount_unit = 2 THEN
		1
	END ),
	(CASE
		WHEN c.hbfx_plan is null THEN
		'--' 
		else
		c.hbfx_plan
	END ),
	round(c.fee_ratio*100,2),
	1,
	1,
	(CASE
		WHEN c.charging_radix = 0 THEN
		'1' 
		WHEN c.charging_radix = 1 THEN
		'2'
		WHEN c.charging_radix = 2 THEN
		'3'
	END ),
	c.ofee_creterion,
	c.charging_plan,
	(CASE
		WHEN c.breach_desc is null THEN
		'--' 
		else
		c.breach_desc
	END ),
	c.provide_time,
	c.rec_gen_time
FROM
	zzxypm.csci_zx_contract c
	LEFT JOIN zzxypm.csci_base_contract bc on c.id = bc.id
	LEFT JOIN zzxypm.csci_contract_signature s ON bc.signature_id = s.id where s.project_id is NOT NULL ;

-- 更新增信函编号
UPDATE pms_contract_credit c SET c.credit_contract_code = (SELECT b.contract_code FROM zzxypm.csci_base_contract b WHERE c.id = b.id) WHERE c.credit_contract_code IS  NULL;

-- 更新首次出函时间
UPDATE pms_project_info p SET p.first_letter_time = (select MIN(t.letter_time) from pms_contract_credit t where t.project_code = p.project_code);

-- 更新征信函服务对象
UPDATE pms_contract_credit t set company_id = IFNULL((SELECT company_id FROM pms_project_org WHERE risk_role_type = 11 and t.project_id = project_id)
,0);
-- 更新征信函服务对象
UPDATE pms_contract_credit t set company_name = IFNULL((SELECT company_name FROM pms_project_org WHERE risk_role_type = 11 and t.project_id = project_id)
,0)	;


-- 投资协议合同迁移
ALTER TABLE `pms_contract_invest` 
MODIFY COLUMN `invest_contract_code` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '投资协议编号' AFTER `invest_contract_name`;
ALTER TABLE `pms_contract_invest` 
MODIFY COLUMN `replay_plan` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收息安排' AFTER `prepayment_state`;
INSERT INTO pms_contract_invest (
	id,
	project_id,
	project_code,
	seal_id,
	company_id,
	company_name,
	invest_contract_name,
	invest_contract_code,
	invest_amount,
	invest_amount_unit,
	invest_standard_unit,
	invest_term,
	invest_term_standard_unit,
	invest_term_time_unit,
	interest_standard,
	prepayment_state,
	replay_plan,
	break_remark,
	create_time
) SELECT
c.id,
s.project_id AS pid,
(
	SELECT
		p.project_code 
	FROM
		zzxypm.csci_base_project p 
	WHERE
		pid = p.id 
	),
	s.id,
	0,
	m.customer_name,
	bc.contract_name,
	bc.contract_code,
	c.invs_amount,
	c.invs_amount_unit,
	1,
	c.duration,
	1,
	(CASE
		WHEN c.duration_unit = 0 THEN
		1 
		WHEN c.duration_unit = 1 THEN
		2
		WHEN c.duration_unit = 2 THEN
		3
	END ),
	(CASE
		WHEN c.CALCRADIX = 360 THEN
		2 
		WHEN c.CALCRADIX = 365 THEN
		1
		ELSE c.CALCRADIX
	END ),
	(CASE
		WHEN c.is_advn_returnable = 0 THEN
		2 
		WHEN c.is_advn_returnable = 1 THEN
		1
	END ),
	c.charging_plan,
	(CASE
		WHEN c.BREACH_DESC is null THEN
		'--' 
		else
		c.BREACH_DESC
	END ),
	c.rec_gen_time
FROM
	zzxypm.csci_tz_contract c
	LEFT JOIN zzxypm.csci_base_contract bc on c.id = bc.id
	LEFT JOIN zzxypm.csci_base_customer m ON bc.customer_id = m.id
	LEFT JOIN zzxypm.csci_contract_signature s ON bc.signature_id = s.id where s.project_id is NOT NULL ;

-- 其它合同迁移
INSERT INTO `pms_contract_file` (
	`project_id`,
	`project_code`,
	`seal_id`,
	`contract_id`,
	`file_name`,
	`file_code`,
	`file_type`,
	`seal_status`,
	`seal_type`,
	`seal_num`,
	`remark`,
	`creator_id`,
	`element_type`,
	`create_time` 
)
SELECT
c.project_id as pid,
p.project_code,
c.signature_id,
c.id,
'',
'',
'',
'',
'',
0,
c.remark,
c.creator,
'5',
c.rec_gen_time
FROM zzxypm.csci_base_contract c LEFT JOIN zzxypm.csci_base_project p ON c.project_id = p.id WHERE c.contract_type = 4 AND p.project_code IS NOT NULL;

-- 更新其它合同要素
UPDATE pms_contract_signature s SET element_type = CONCAT(element_type, ',5') WHERE s.id IN ( SELECT f.seal_id FROM pms_contract_file f WHERE f.element_type = '5');



-- 增信项目要素迁移脚本
ALTER TABLE `pms_project_credit_info` 
MODIFY COLUMN `repay_plan` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '还本付息安排' AFTER `issue_deadline_time_unit`;
ALTER TABLE `pms_project_credit_info` 
MODIFY COLUMN `issue_scope` varchar(350) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '责任金额及范围' AFTER `duty_cost_amount_unit`;
INSERT INTO pms_project_credit_info (
	project_id,
	project_code,
	product_type,
	issue_scale,
	issue_scale_range_unit,
	issue_scale_amount_unit,
	credit_type,
	issue_deadline,
	issue_deadline_standard_unit,
	issue_deadline_time_unit,
	repay_plan,
	credit_rate,
	credit_rate_standard_unit,
	credit_rate_time_unit,
	duty_cost,
	duty_cost_standard_unit,
	duty_cost_amount_unit,
	issue_scope,
	charge_plan,
	create_time
) SELECT
t.ID as pid,
(
	SELECT
		p.project_code 
	FROM
		zzxypm.csci_base_project p 
	WHERE
		pid = p.id 
	),
	(CASE
		WHEN p.ptype_id = 0 THEN
		1 
		WHEN p.ptype_id = 1 THEN
		2
		WHEN p.ptype_id = 2 THEN
		7
		WHEN p.ptype_id = 3 THEN
		8
		WHEN p.ptype_id = 4 THEN
		9
		WHEN p.ptype_id = 5 THEN
		10
		WHEN p.ptype_id = 6 THEN
		11
		WHEN p.ptype_id = 7 THEN
		12
		WHEN p.ptype_id = 8 THEN
		13
		WHEN p.ptype_id = 9 THEN
		14
		WHEN p.ptype_id = 10 THEN
		3
		WHEN p.ptype_id = 11 THEN
		4
		WHEN p.ptype_id = 12 THEN
		5
		WHEN p.ptype_id = 13 THEN
		6
	END ),
	IFNULL(t.issuing_scale,0)*100000000,
	(CASE
		WHEN t.issuing_scale_limit = 0 THEN
		1 
		WHEN t.issuing_scale_limit = 1 THEN
		4
		WHEN t.issuing_scale_limit = 2 THEN
		5
	END ),
	1,
	t.addtion_type,
	IFNULL(t.issuing_limit,''),
	2,
	1,
	t.hbfx_arrange,
	round(t.fee_ratio,2),
	1,
	1,
	IFNULL(t.zx_check_amount+t.tz_check_amount,0),
	1,
	3,
	IFNULL(t.duty_scope,''),
	t.charging_way,
	t.rec_gen_time
FROM zzxypm.csci_zx_project t , zzxypm.csci_base_project p where t.ID = p.id;


-- 增信项目合作机构迁移脚本
INSERT INTO pms_project_coo(
project_id,
project_code,
company_id,
company_name,
credit_code,
cooperative_org_type,
contacts_phone,
contacts_name,
create_time)
SELECT t.ID as pid,
(
	SELECT
		p.project_code 
	FROM
		zzxypm.csci_base_project p 
	WHERE
		pid = p.id 
	),
	0,
	t.coagency_name,
	'',
	(CASE
		WHEN t.coagency_type = 0 THEN
		1 
		WHEN t.coagency_type = 1 THEN
		2
		WHEN t.coagency_type = 2 THEN
		4
		WHEN t.coagency_type = 3 THEN
		5
		WHEN t.coagency_type = 4 THEN
		6
		WHEN t.coagency_type = 5 THEN
		7
		WHEN t.coagency_type = 6 THEN
		8
		WHEN t.coagency_type = 7 THEN
		9
		WHEN t.coagency_type = 8 THEN
		10
		WHEN t.coagency_type = 9 THEN
		11
		WHEN t.coagency_type = 10 THEN
		3
		ELSE 9
	END ),
	'',
	'',
	t.rec_gen_time	
	 FROM zzxypm.csci_zx_project t WHERE t.coagency_name IS NOT NULL  and t.ID in (select id from zzxypm.csci_base_project );



-- 投资产品要素数据迁移
ALTER TABLE `pms_project_invest_info` 
MODIFY COLUMN `repay_plan` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '还本付息安排' AFTER `earnings_rate_time_unit`;
INSERT INTO pms_project_invest_info (
	project_id,
	project_code,
	product_type,
	invest_amount,
	invest_amount_unit,
	invest_standard_unit,
	invest_term,
	invest_term_standard_unit,
	invest_term_time_unit,
	earnings_rate,
	earnings_rate_standard_unit,
	earnings_rate_time_unit,
	repay_plan,
	early_termination,
	create_time
) SELECT
t.ID as pid,
(
	SELECT
		p.project_code 
	FROM
		zzxypm.csci_base_project p 
	WHERE
		pid = p.id 
	),
	(CASE
		WHEN p.ptype_id = 0 THEN
		1 
		WHEN p.ptype_id = 1 THEN
		2
		WHEN p.ptype_id = 2 THEN
		7
		WHEN p.ptype_id = 3 THEN
		8
		WHEN p.ptype_id = 4 THEN
		9
		WHEN p.ptype_id = 5 THEN
		10
		WHEN p.ptype_id = 6 THEN
		11
		WHEN p.ptype_id = 7 THEN
		12
		WHEN p.ptype_id = 8 THEN
		13
		WHEN p.ptype_id = 9 THEN
		14
		WHEN p.ptype_id = 10 THEN
		3
		WHEN p.ptype_id = 11 THEN
		4
		WHEN p.ptype_id = 12 THEN
		5
		WHEN p.ptype_id = 13 THEN
		6
	END ),
	IFNULL(t.invst_amount,0)*100000000,
	1,
	1,
	IFNULL(t.fduration,''),
	(CASE
		WHEN t.fduration like '%+%' THEN
		2 
		ELSE
		1
	END ),
	(CASE
		WHEN t.fduration_unit = 0 THEN
		1 
		WHEN t.fduration_unit = 1 THEN
		2
		WHEN t.fduration_unit = 2 THEN
		3
	END ),
	round(IFNULL(t.finterest_rate,0),2),
	1,
	1,
	IFNULL(t.sx_method,''),
	(CASE
		WHEN t.is_advn_terminable = 0 THEN
		2 
		WHEN t.is_advn_terminable = 1 THEN
		1
	END ),
	t.rec_gen_time
FROM zzxypm.csci_tz_project t , zzxypm.csci_base_project p WHERE t.ID = p.id;


-- 融资服务协议数据迁移
ALTER TABLE `pms_contract_finance` 
MODIFY COLUMN `finance_contract_code` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '增信函编号' AFTER `finance_contract_name`;
ALTER TABLE `pms_contract_finance` 
MODIFY COLUMN `replay_plan` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '还本付息安排' AFTER `charge_mode`;
ALTER TABLE `pms_contract_finance` 
MODIFY COLUMN `charge_mode` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '收费方式' AFTER `charge_number_other`;
ALTER TABLE `zzxypm_uat`.`pms_contract_finance` 
MODIFY COLUMN `finance_rate` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '融资费率' AFTER `target_amount_unit`;

INSERT INTO pms_contract_finance (
	id,
	project_id,
	project_code,
	seal_id,
	company_id,
	company_name,
	finance_contract_name,
	finance_contract_code,
	issue_deadline,
	issue_deadline_standard_unit,
	issue_deadline_time_unit,
	target_amount,
	target_amount_standard_unit,
	target_amount_unit,
	finance_rate,
	finance_rate_standard_unit,
	finance_rate_time_unit,
	charge_number,
	charge_number_other,
	charge_mode,
	replay_plan,
	finance_type,
	create_time
) SELECT
c.id,
s.project_id AS pid,
(
	SELECT
		p.project_code 
	FROM
		zzxypm.csci_base_project p 
	WHERE
		pid = p.id 
	),
	s.id,
	0,
	c.service_object,
	bc.contract_name,
	bc.contract_code,
	c.issue_duration,
	(CASE
		WHEN c.issue_duration like '%+%' THEN
		2 
		ELSE
		1
	END ),
	(CASE
		WHEN c.fxq_unit = 0 THEN
		1 
		WHEN c.fxq_unit = 1 THEN
		2
		WHEN c.fxq_unit = 2 THEN
		3
	END ),
	c.issue_amount,
	1,
	(CASE
		WHEN c.issue_amount_unit = 0 THEN
		3 
		WHEN c.issue_amount_unit = 1 THEN
		2
		WHEN c.issue_amount_unit = 2 THEN
		1
	END ),
	round(c.fee_rate*100,2),
	1,
	1,
	(CASE
		WHEN c.fee_base = 0 THEN
		1 
		WHEN c.fee_base = 1 THEN
		2
		WHEN c.fee_base = 2 THEN
		3
	END ),
	c.qt_fee_base,
	IFNULL(c.charging_plan,''),
	IFNULL(c.hbfx_plan,''),
	(CASE
		WHEN c.target_type = 0 THEN
		1 
		WHEN c.target_type = 1 THEN
		2
		WHEN c.target_type = 2 THEN
		3
	END ),
	c.rec_gen_time
FROM
	zzxypm.csci_gwfw_contract c
	LEFT JOIN zzxypm.csci_base_contract bc on c.id = bc.id
	LEFT JOIN zzxypm.csci_contract_signature s ON bc.signature_id = s.id where s.project_id is NOT NULL ;



-- 更新项目进程-未过会
UPDATE pms_project_info p set p.project_process = '1' WHERE p.first_meeting_time is null;
-- 更新项目进程-已过会
UPDATE pms_project_info p set p.project_process = '2' WHERE p.first_meeting_time is not null;
-- 更新项目进程-已出函待发行
UPDATE pms_project_info p set p.project_process = '3' WHERE p.first_letter_time is not null and p.first_issue_time is null;
-- 更新项目进程-已出函待发行
UPDATE pms_project_info p set p.project_process = '3' WHERE p.first_issue_time is not null and NOT EXISTS (SELECT i.id FROM zzxypm.csci_issue_info i WHERE p.id = i.project_id and i.`status` = 1 );
-- 更新项目进程-已发行待结束/已放款待结束
UPDATE pms_project_info p set p.project_process = '4' WHERE p.first_issue_time is not null and EXISTS (SELECT i.id FROM zzxypm.csci_issue_info i WHERE p.id = i.project_id and i.`status` = 1);

-- 更新项目进程-发行已结束/放款已结束	
-- UPDATE pms_project_info p set p.project_process = '5' WHERE p.first_issue_time is not null;
-- 更新项目进程-已归档
UPDATE pms_project_info p set p.project_process = '6' WHERE p.status = '4';



-- 更新合同流程id
UPDATE pms_contract_signature s SET pins_id = (SELECT p.INS_ID FROM 
       zzxypm.lmsp_lbpm_histinsprop p,pms_contract_credit c WHERE s.id = c.seal_id  AND p.prop_value=c.seal_id
     and p.PROP_KEY= "contractId" );

UPDATE pms_contract_signature s SET pins_id = (SELECT p.INS_ID FROM 
       zzxypm.lmsp_lbpm_insprop p,pms_contract_credit c WHERE s.id = c.seal_id  AND p.prop_value=c.seal_id
     and p.PROP_KEY= "contractId" ) WHERE s.pins_id is null;
	 
UPDATE pms_contract_signature s SET pins_id = (SELECT p.INS_ID FROM 
       zzxypm.lmsp_lbpm_histinsprop p,pms_contract_invest	c WHERE s.id = c.seal_id  AND p.prop_value=c.seal_id
     and p.PROP_KEY= "contractId" ) WHERE s.pins_id is null;

UPDATE pms_contract_signature s SET pins_id = (SELECT p.INS_ID FROM 
       zzxypm.lmsp_lbpm_insprop p,pms_contract_invest c WHERE s.id = c.seal_id  AND p.prop_value=c.seal_id
     and p.PROP_KEY= "contractId" ) WHERE s.pins_id is null;

UPDATE pms_contract_signature s SET pins_id = (SELECT p.INS_ID FROM 
       zzxypm.lmsp_lbpm_histinsprop p,pms_contract_finance	c WHERE s.id = c.seal_id  AND p.prop_value=c.seal_id
     and p.PROP_KEY= "contractId" ) WHERE s.pins_id is null;

UPDATE pms_contract_signature s SET pins_id = (SELECT p.INS_ID FROM 
       zzxypm.lmsp_lbpm_insprop p,pms_contract_finance c WHERE s.id = c.seal_id  AND p.prop_value=c.seal_id
     and p.PROP_KEY= "contractId" ) WHERE s.pins_id is null;

UPDATE pms_contract_signature s SET pins_id = (SELECT p.INS_ID FROM 
       zzxypm.lmsp_lbpm_histinsprop p,zzxypm.csci_base_contract	c WHERE s.id = c.signature_id  AND p.prop_value=c.signature_id
     and p.PROP_KEY= "contractId" ) WHERE s.pins_id is null;

		 
UPDATE pms_contract_signature s SET pins_id = (SELECT p.INS_ID FROM 
       zzxypm.lmsp_lbpm_insprop p,zzxypm.csci_base_contract	c WHERE s.id = c.signature_id  AND p.prop_value=c.signature_id
     and p.PROP_KEY= "contractId" ) WHERE s.pins_id is null;



-- 项目贡献
INSERT INTO `zzxypm_uat`.`pms_project_contribution` (
	`id`,
	`contribution_code`,
	`project_id`,
	`project_name`,
	`project_managerA_name`,
	`project_code`,
	`year`,
	`season`,
	`dept_id`,
	`dept_name`,
	`create_user_id`,
	`create_user_name`,
	`push_date`,
	`title`,
	`pins_id`,
	`status`,
	`create_time`
) SELECT
p.id,
'',
l.project_id,
j.project_name,
m.MEMBER_NAME,
j.project_code,
YEAR(p.send_time),
0,
0,
'系统',
0,
'系统',
p.send_time,
p.send_title,
'',
(CASE
		 
		WHEN l.zt_status = '已结束' THEN
		'2' 
		ELSE '1' 
	END ),
p.create_time
FROM
	zzxypm.csci_project_contribution_plan p
	LEFT JOIN zzxypm.csci_project_contribution_plan_link l ON p.id = l.plan_id
	LEFT JOIN zzxypm.csci_base_project j ON l.project_id = j.id
	LEFT JOIN zzxypm.l_member m ON j.chief = m.MEMBER_ID;

-- 项目贡献明细
INSERT INTO `pms_project_contribution_member` (
	`contribution_id`,
	`contribution_type`,
	`member_type`,
	`member_user_id`,
	`member_role_id`,
	`member_dept_id`,
	`member_user_name`,
	`member_role_name`,
	`member_dept_name`,
	`contribution_ration`,
	`create_user_id`,
	`create_time`
)
SELECT
m.plan_id,
(CASE
		WHEN PROJ_ADVN_CNTR_ID = '2' THEN
		'1' 
		WHEN PROJ_ADVN_CNTR_ID = '3' THEN
		'2' 
		ELSE PROJ_ADVN_CNTR_ID
	END ),
(CASE
		WHEN a.XMJDMC LIKE '承揽%' THEN
		'1' 
		WHEN a.XMJDMC LIKE '承做%' THEN
		'2' 
	END ),
m.MEMBER_ID as mid,
0,
(SELECT MIN(p.dept_id) FROM zzxypm_uat.sys_user_dept p WHERE p.user_id = mid AND p.is_principal = '1') as did, 
(SELECT u.`name` from sys_user u WHERE u.id = mid),
a.RYGW,
(SELECT d.full_name FROM sys_dept d WHERE did = d.id), 
m.CONTRIBUTION_RATIO,
m.CREATOR,
m.REC_GEN_TIME
FROM zzxypm.csci_project_member_contribution m LEFT JOIN zzxypm.achievements_member a ON m.PROJECT_ID = a.XMID and m.MEMBER_ID = a.XMCY AND m.CONTRIBUTION_RATIO = a.GXZ;




-- 待定脚本
INSERT INTO pms_contract_file (
	id,
	project_id,
	project_code,
	contract_id,
	seal_id,
	file_name,
	file_code,
	file_type,
	seal_status,
	seal_type,
	seal_num,
	creator_id,
element_type,
create_time)
SELECT
t.business_id,
t.project_id as pid,
(SELECT p.project_code FROM pms_project_info p where pid = p.id),
a.id,
IFNULL(a.seal_id,0) ,
t.file_name,
t.file_id,
'',
'',
'',
0,
t.uploader_id,
'1',
t.create_time
FROM sys_attachment t LEFT JOIN pms_contract_credit a ON a.id = t.business_id WHERE t.business_type = 'CONTRACT_SIGNATURE_FILE' and t.project_id IS NOT NULL


-- 审批附件迁移	已废弃
INSERT INTO sys_attachment (project_id,business_type,business_id,file_id,file_name,remark,instance_id,uploader_id,uploader_name,file_path,create_time)
SELECT
	c.project_id,
(CASE
		 
		WHEN c.scene_type = 'contract' THEN
		'CONTRACT_SIGNATURE_FILE' 
		WHEN c.scene_type = 'issue' THEN
		'ISSUE_INFO_FILE' 
		WHEN c.scene_type = 'initiation' THEN
		'APPLICATION_FORM' ELSE 'PROCESS_FILE' 
	END ),
pr.record_id,
c.file_id,
c.file_name AS fileName,
c.remark,
pr.proc_inst_id AS pinstId,
c.uploader AS uploader,
( SELECT m.member_name FROM zzxypm.l_member m WHERE c.uploader = m.member_id ) ,
'',
c.rec_gen_time
FROM
	zzxypm.csci_process_document pr
	LEFT JOIN zzxypm.csci_attachment c ON pr.atta_id = c.id
	LEFT JOIN zzxypm.csci_project_audit_record pro ON pro.id = pr.record_id
	WHERE c.file_name is not null;


--更新合同附件项目id 已废弃
UPDATE sys_attachment t set t.project_id = (SELECT c.project_id FROM zzxypm.csci_base_contract c WHERE t.business_id = c.id) WHERE t.business_type = 'CONTRACT_SIGNATURE_FILE' and t.project_id IS NULL	





-- 备用sql						
UPDATE pms_project_info p 
SET p.risk_type = (SELECT
(
	CASE
			
			WHEN t.risk_type = 1 THEN
			'不良资产' 
			WHEN t.risk_type = 2 THEN
			'城投' 
			WHEN t.risk_type = 3 THEN
			'产业类' 
			WHEN t.risk_type = 4 THEN
			'中小微' 
			WHEN t.risk_type = 5 THEN
			'金融' 
			WHEN t.risk_type = 6 THEN
			'消费金融' 
			WHEN t.risk_type = 7 THEN
			'保本基金' 
			WHEN t.risk_type = 8 THEN
			'其它' 
			WHEN t.risk_type = 9 THEN
			'对内增信' 
			WHEN t.risk_type = 10 THEN
			'CDS' 
			WHEN t.risk_type = 11 THEN
			'ABS次级' 
		END 
		) 
	FROM
		zzxypm.csci_base_project t 
WHERE
	p.id = t.id);
	
	
UPDATE pms_project_info p 
SET p.risk_type = (SELECT
(
	CASE
			
			WHEN t.sonProTypeId = 1 THEN
			'不良资产' 
			WHEN t.sonProTypeId = 2 THEN
			'城投' 
			WHEN t.sonProTypeId = 3 THEN
			'产业类' 
			WHEN t.sonProTypeId = 4 THEN
			'中小微' 
			WHEN t.sonProTypeId = 5 THEN
			'金融' 
			WHEN t.sonProTypeId = 6 THEN
			'消费金融' 
			WHEN t.sonProTypeId = 7 THEN
			'保本基金' 
			WHEN t.sonProTypeId = 8 THEN
			'其它' 
			WHEN t.sonProTypeId = 9 THEN
			'对内增信' 
			WHEN t.sonProTypeId = 10 THEN
			'CDS' 
			WHEN t.sonProTypeId = 11 THEN
			'ABS次级' 
		END 
		) 
	FROM
		zzxypm.csci_base_project t 
WHERE
	p.id = t.id);

-- 更新用印流程实例id
update pms_contract_signature s SET s.pins_id = (select  INS_ID from zzxypm.lmsp_lbpm_histinsprop h where h.prop_key='contractId'  and h.prop_value=s.id)