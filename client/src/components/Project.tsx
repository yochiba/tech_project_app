import React, {useState, useEffect} from 'react';
import {useParams} from 'react-router-dom';
import Axios from 'axios';
import * as Common from '../constants/common';

type ParamTypes = {
  pjtId: string;
}

type ProjectData = {
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
  max_price: number;
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

const initProjectData: ProjectData = {
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
    max_price: 0,
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
  const [projectData, setProjectData] = useState<ProjectData>(initProjectData);

  useEffect(() => {
    const projectId: InitProjectParams = {
      pjtId: Number(pjtId),
    }

    Axios.get(`${Common.API_ENDPOINT}search/show`, {
      params: projectId,
    })
    .then((res) => {
      setProjectData(res.data);
    })
    .catch((res) => {
      console.log(res);
    })
  }, [pjtId])

  window.scrollTo(0, 0);
  return(
    <div className='project'>
      <section className='pjt-box'>
        <h1 className='pjt-title'>{projectData.project.title}</h1>
        <div className='pjt-table-container'>
          <table className='pjt-summary-table'>
            {
              Common.PROJECT_SUMMARY_TITLE.map((title: string) => {
                return pjtSummary(title, projectData.project);
              })
            }
          </table>
          <table className='pjt-tags-table'>
            {
              Common.PROJECT_TAGS_TITLE.map((title: string) => {
                return pjtTags(title, projectData.project);
              })
            }
          </table>
        </div>
        {affiliateUrl(projectData.project.affiliate_url)}
        <ul>
          {
            Common.PROJECT_DETAIL_TITLE.map((title: string, index: number) => {
              return pjtDetail(title, projectData.project, index);
            })
          }
        </ul>
        {affiliateUrl(projectData.project.affiliate_url)}
      </section>
    </div>
  );
}

// for pjt-summary-table
const pjtSummary = (title: string, project: ProjectHash) => {
  let value: string = '';
  switch (title) {
    case '勤務地':
      value = project.location_name;
      break;
    case '単価':
      const minPrice: number = project.min_price;
      const maxPrice: number = project.max_price;

      const minPriceStr: string = minPrice === 0 || minPrice === null ? '' : String(minPrice.toLocaleString());
      const maxPriceStr: string = maxPrice === 0 || maxPrice === null ? '' : String(maxPrice.toLocaleString());

      if (minPriceStr !== '' || maxPriceStr !== '') {
        value = `${minPriceStr}~${maxPriceStr}${project.price_unit}`;
      } else {
        value = '';
      }
      break;
    case '稼働時間':
      const minOperation: number = project.min_operation_unit;
      const maxOperation: number = project.max_operation_unit;

      const minOperationStr: string = minOperation === 0 || minOperation === null ? '' : minOperation.toString();
      const maxOperationStr: string = maxOperation === 0 || maxOperation === null ? '' : maxOperation.toString();

      if (minOperationStr !== '' || maxOperationStr !== '') {
        value = `${minOperationStr}~${maxOperationStr}${project.operation_unit}`;
      } else {
        value = '';
      }
      break;
    case '契約形態':
      value = project.contract_name;
      break;
    case '週稼働日数':
      const weeklyAttendance: number = project.weekly_attendance;
      value = weeklyAttendance === 0 || weeklyAttendance === null ? '' : String(project.weekly_attendance);
      break;
    default:
      break;
  }

  if (value !== null && value !== '') {
    return (
      <tr>
        <th>
          {title}：
        </th>
        <td>
          {value}
        </td>
      </tr>
    );
  } else {
    return null;    
  }
}

const pjtTags = (title: string, project: ProjectHash) => {
  let valueList: string[] = [];
  switch (title) {
    case 'ポジション':
      valueList = project.position_name_list;
      break;
    case '業界':
      valueList = project.industry_name_list;
      break;
    case 'タグ':
      valueList = project.tag_name_list;
      break;
    default:
      break;
  }

  if (valueList !== null) {
    return (
      <tr>
        <th>
          {title}：
        </th>
        <td>
          {valueList.map((value: string) => {
            return (
              <div className='tag'>
                {value}
              </div>
            );
          })}
        </td>
      </tr>
    );
  } else {
    return null;    
  }
}

// 案件詳細
const pjtDetail = (title: string, project: ProjectHash, index: number) => {
  let value: string = '';
  switch (title) {
    case '案件内容':
      value = project.description;
      break;
    case '必須スキル':
      value = project.required_skills;
      break;
    case '歓迎スキル':
      value = project.other_skills;
      break;
    case '開発環境':
      value = project.environment;
      break;
    default:
      break;
  }

  if (value !== null && value !== '' ) {
    return (
      <li className='pjt-detail-li' key={`pjtLi${index}`}>
        <h3 className='pjt-detail-title'>{title}</h3>
        <p className='pjt-detail-value'>{value}</p>
      </li>
    );
  } else {
    return null;
  }
}

// アフィリエイトリンク
const affiliateUrl = (url: string) => {
  return (
    <div className='affiliate-link'>
      <a href={url} target='_blank' rel='noreferrer'>
        {Common.AFFILIATE_LINK_TITLE}
      </a>
    </div>
  );
}

export default Project