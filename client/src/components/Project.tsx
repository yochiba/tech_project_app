import React, {useState, useEffect} from 'react';
import {useParams} from 'react-router-dom';
import Axios from 'axios';
import * as Common from '../constants/common';

type ParamTypes = {
  pjtId: string;
}

type projectData = {
  status: number;
  result: string;
  project: ProjectHash;
}

type ProjectHash = {
  id: number;
  title: string;
  description: string;
  company_id: number;
  company: string;
  url: string;
  affiliate_url: string;
  required_skills: string;
  other_skills: string;
  environment: string;
  weekly_attendance: number;
  min_operation_unit: number;
  max_operation_unit: number;
  operation_unit_id: number;
  operation_unit: string;
  min_price: number;
  max_price: string;
  price_unit_id: number;
  price_unit: string;
  location_id: number;
  contract_id: number;
  display_flg: string;
  deleted_flg: string;
  deleted_at: Date;
  created_at: Date;
  updated_at: Date;
  location_name: string;
  contract_name: string;
  position_name_list: string[];
  position_name_search_list: string[];
  industry_name_list: string[];
  industry_name_search_list: string[];
  tag_name_list: string[];
  tag_name_search_list: string[];
}

const currentDate: Date = new Date();

const initProjectData: projectData = {
  status: 204,
  result: 'NO CONTENT',
  project: {
    id: 0,
    title: '',
    description: '',
    company_id: 0,
    company: '',
    url: '',
    affiliate_url: '',
    required_skills: '',
    other_skills: '',
    environment: '',
    weekly_attendance: 0,
    min_operation_unit: 0,
    max_operation_unit: 0,
    operation_unit_id: 0,
    operation_unit: '',
    min_price: 0,
    max_price: '',
    price_unit_id: 0,
    price_unit: '',
    location_id: 0,
    contract_id: 0,
    display_flg: '',
    deleted_flg: '',
    deleted_at: currentDate,
    created_at: currentDate,
    updated_at: currentDate,
    location_name: '',
    contract_name: '',
    position_name_list: [],
    position_name_search_list: [],
    industry_name_list: [],
    industry_name_search_list: [],
    tag_name_list: [],
    tag_name_search_list: [],
  }
}

type InitProjectParams = {
  pjtId: number;
}

const Project: React.FC = () => {
  const { pjtId } = useParams<ParamTypes>();
  const [projectData, setProjectData] = useState<projectData>(initProjectData);

  useEffect(() => {
    const projectId: InitProjectParams = {
      pjtId: Number(pjtId),
    }

    Axios.get(`${Common.API_ENDPOINT}projects/show`, {
      params: projectId,
    })
    .then((res) => {
      setProjectData(res.data);
    })
    .catch((res) => {
      console.log(res);
    })
  }, [projectData.status])

  window.scrollTo(0, 0);
  const minPriceStr: string = projectData.project.min_price === 0 || null ? '' : String(projectData.project.min_price.toLocaleString());
  const maxPriceStr: string = String(projectData.project.max_price.toLocaleString());

  const minOperationStr: string = projectData.project.min_operation_unit === 0 || null ? '' : projectData.project.min_operation_unit.toString();
  const maxOperationStr: string = projectData.project.max_operation_unit === 0 || null ? '' : projectData.project.max_operation_unit.toString();
  return(
    <div>
      <section className='project'>
        <h1>{projectData.project.title}</h1>
        <h3>勤務地</h3>
        {projectData.project.location_name}
        <h3>単価</h3>
        {minPriceStr}~{maxPriceStr}{projectData.project.price_unit}
        <h3>案件内容</h3>
        <p>{projectData.project.description}</p>
        <h3>必須スキル</h3>
        <p>{projectData.project.required_skills}</p>
        <h3>歓迎スキル</h3>
        <p>{projectData.project.other_skills}</p>
        <h3>開発環境</h3>
        <p>{projectData.project.environment}</p>
        <h3>稼働時間</h3>
        {minOperationStr}~{maxOperationStr}{projectData.project.operation_unit}
        <h3>週稼働日数</h3>
        {projectData.project.weekly_attendance}
        <h3>契約形態</h3>
        {projectData.project.contract_name}
        {/* <h3>ポジション</h3>
        {projectData.project.position_name_list.map((position: string) => {
          return(
            {position}
          );
        })}
        <h3>業界</h3>
        {projectData.project.industry_name_list.map((industry: string) => {
          return(
            {industry}
          );
        })}
        <h3>タグ</h3>
        {projectData.project.tag_name_list.map((tag: string) => {
          return(
            {tag}
          );
        })} */}
      </section>
    </div>
  );
}

export default Project