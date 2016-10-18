drop table if exists scratch.rc_drg_flg;
create table scratch.rc_drg_flg as

with drugs_baby_bh as (select distinct
drg_product_service_identification as ndc,
drg_product_service_name as drug_name,
-- prv_prescriber_specialty_description,
-- prv_prescriber_practitioner_type,
drg_tcc_standard_description,
drg_tcc_specific_description,
drg_ahfs_therapeutic_class_code_description,
--drg_generic_product_flag,
drg_class_code,
drg_dea_code,
--drg_part_d_covered_yn,
drg_maintenance_drug_flag,
clm_formulary_flag
--dct_price_identifier,
--dct_used_price_code
from transactional.raw_claim where drg_product_service_identification is not null)

, drugs_baby_aarx as (select distinct
drg_product_service_identification as ndc,
drg_product_service_name as drug_name,
-- prv_prescriber_specialty_description,
-- prv_prescriber_practitioner_type,
drg_tcc_standard_description,
drg_tcc_specific_description,
drg_ahfs_therapeutic_class_code_description,
--drg_generic_product_flag,
drg_class_code,
drg_dea_code,
--drg_part_d_covered_yn,
drg_maintenance_drug_flag,
clm_formulary_flag
--dct_price_identifier,
--dct_used_price_code
from aarx.raw_claim where drg_product_service_identification is not null)

, drugs_baby1 as (
select * from drugs_baby_aarx 
union select * from drugs_baby_bh)

, drugs_baby2 as (
select x.* 
,y.gcn as gcn
,y.hicl_desc as hicl_desc
,y.med_name as med_name
,y.med_name_id as med_name_id
from drugs_baby1 x
left join dw.drugs y on x.ndc = y.ndc)

select * from drugs_baby2;

select distinct gcn from scratch.rc_drg_flg where clm_formulary_flag = 'N' and gcn is not null;
select distinct gcn from scratch.rc_drg_flg where drg_maintenance_drug_flag = 'Y' and gcn is not null;
select distinct gcn from scratch.rc_drg_flg where drg_class_code = 'O' and gcn is not null;
select gcn,max(drg_dea_code) as max_dea_code from scratch.rc_drg_flg where drg_dea_code is not null and gcn is not null and drg_dea_code > 0 group by 1;
 
