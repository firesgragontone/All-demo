--项目信息迁移脚本
insert into pms_project_info(id,project_code,project_name,project_desc,project_phase,project_type,project_pass)
	select t.id abc,t.project_code,t.project_name,t.project_desc,
	(case when cstn = '尽调阶段' then '10'
	      when cstn = '质控' then '30'
	      when cstn = '合规风控' then '40'
	      when cstn = '合同阶段' then '50'
	 end),
	(case when t.'status' = 'pausing' then '2'
	 case when t.'status' = 'terminated' then '3'
	 case when t.'status' = 'archived' then '4'
	 else '1'
	 end),
	(select MAX(ph.project_pass) from zzxypm.csci_project_passed_his ph where abc = ph.project_code), 
    (select SUM(IFNULL(p.zx_pass_amount,0)) + SUM(IFNULL(p.tz_pass_amount,0)) from zzxypm.csci_project_passed_his p where abc = p.project_id),
    (select MAX(zc.provide_time) from zzxypm.csci_contranct_signature cs, zzxypm.csci_zxcontract ac where cs.id = zc.id and abc = cs.project_id),
    from zzxypm.csci_base_project t where proTypeId = '1' or proTypeId = '3'

--
update pms_project_info set org_type = '1' where risk_role_type = '11'
update pms_project_info set project_name = '哈哈' where risk_role_type = '11'

ALTER TABLE `pms_project_risk_mitigants` MODIFY COLUMN `risk_explain` varchar(1024)	CHARACTER SET utf8 utf8_general_ci NULL DEFAULT NULL COMMENT '风险缓释措施说明' AFTER `risk_mitigants`

insert into sys_user(id,account,`name`,`password`,salt,birthday,email,address,phone) select () from zzxypm.l_user u left join zzxypm.l_member m on u.member_id = m.member_id;
