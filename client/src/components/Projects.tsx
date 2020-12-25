import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import Axios from 'axios';
import * as Common from '../constants/common';

type ProjectsData = {
  status: number;
  result: string;
  pjt_count: number
  current_page: number;
  sort: string;
  total_pjt_count: number;
  total_pages: number;
  pjt_list: ProjectHash[];
}

type ProjectHash = {
  id: number;
  title: string;
  description: string;
  company_id: number;
  company: string;
  url: string;
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
  display_flg: number;
  deleted_flg: number;
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

const initProjectsData: ProjectsData = {
  status: 204,
  result: 'NO CONTENT',
  pjt_count: 0,
  current_page: 1,
  sort: 'created_at DESC',
  total_pjt_count: 0,
  total_pages: 1,
  pjt_list: []
}

type initProjectListParams = {
  page: number;
  sort: string;
}

const Projects: React.FC = () => {

  const [projectsData, setProjectsData] = useState(initProjectsData);

  useEffect(() => {
    const initProjectListParams: initProjectListParams = {
      page: projectsData.current_page,
      sort: 'created_at DESC',
    }
  
    Axios.get(`${Common.API_ENDPOINT}projects/index`, {
      params: initProjectListParams,
    })
    .then((res) => {
      setProjectsData(res.data);
      // localStorage.setItem('projectsData', JSON.stringify(res.data));
      // console.log(localStorage.getItem('projectsData'));
    })
    .catch((res) => {
      console.log(res);
    })
  }, [projectsData.current_page])

  window.scrollTo(0, 0);
  return (
    <div>
      <section className='pjt-list'>
        <ul>
          {
            projectsData.pjt_list.map((pjt: ProjectHash, indexPjt: number) => {
              const minPriceStr: string = pjt.min_price === 0 || null ? '' : String(pjt.min_price.toLocaleString());
              const maxPriceStr: string = String(pjt.max_price.toLocaleString());
              return (
                <li className='pjt-box' key={`pjt${indexPjt}`}>
                  <Link to={`/project/${pjt.id}`} className='pjt-link' key={`pjtLink${indexPjt}`}>
                    <h2 className='pjt-title'>{pjt.title}</h2>
                  </Link>
                  <div className='pjt-summary'>
                    <ul>
                      <li className='pjt-price' key={`pjtPrice${indexPjt}`}>
                        単価：{minPriceStr}~{maxPriceStr}円
                      </li>
                      <li className='pjt-location' key={`pjtLocation${indexPjt}`}>
                        最寄駅：{pjt.location_name}
                      </li>
                      <li className={`pjtTags${indexPjt}`}>
                        {tagList(pjt)}
                        <li className='pjtUpdatedAt' key={`pjtUpdatedAt${indexPjt}`}>
                          更新日：{pjt.updated_at}
                        </li>
                      </li>
                    </ul>
                  </div>
                  <h3 className='pjt-company'>From {pjt.company}</h3>
                </li>
              );
            })
          }
        </ul>
        <div className='pjt-page-btn'>
          {
            [...Array(projectsData.total_pages)].map((_, index: number) => {
              let page: number = index + 1;
              return(
                <>
                  <button 
                    onClick={() => {setProjectsData({...projectsData,current_page: page})}}
                    key={`pageButton${page}`}
                  >
                    {page}
                  </button>
                </>
              );
            })
          }
        </div>
      </section>
    </div>
  )
}

// タグ一覧
const tagList = (pjt: ProjectHash) => {
  const tagNameList: string[] = pjt.tag_name_list;
  if (tagNameList !== null) {
    return(
      <ul>
        タグ：{tagNameList.map((tag_name: string, indexTagName: number) => {
          return(
            <li
              className='pjtTagName'
              key={`pjtTagName${indexTagName}`}
            >
              {tag_name}
            </li>
          );
        })}
      </ul>
    )
  }
}

export default Projects