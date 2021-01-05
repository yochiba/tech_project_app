import React, { useState, useEffect } from 'react';
import { Link, useLocation, useHistory } from 'react-router-dom';
import Axios from 'axios';
import * as Common from '../constants/common';

type SearchParams = {
  page: number;
  sort: string;
  tags: string;
  locations: string;
  contracts: string;
  positions: string;
  industries: string;
  keyword: string;
}

const initSearchParams = {
  page: Common.FIRST_PAGE,
  sort: Common.SORT_QUERY_LATEST,
  tags: '',
  locations: '',
  contracts: '',
  positions: '',
  industries: '',
  keyword: '',
}

type ProjectsData = {
  status: number;
  result: string;
  pjtCount: number
  currentPage: number;
  sort: string;
  totalPjtCount: number;
  totalPages: number;
  pjtList: ProjectHash[];
  searchParams: SearchParams;
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
  pjtCount: 0,
  currentPage: Common.FIRST_PAGE,
  sort: 'created_at DESC',
  totalPjtCount: 0,
  totalPages: 1,
  pjtList: [],
  searchParams: initSearchParams,
}

type SortHash = {
  title: string;
  sort: string;
}

const SORT_LIST: SortHash[] = [
  {
    title: Common.SORT_TITLE_LATEST,
    sort: Common.SORT_QUERY_LATEST,
  },
  {
    title: Common.SORT_TITLE_OLDEST,
    sort: Common.SORT_QUERY_OLDEST,
  },
  {
    title: Common.SORT_TITLE_PRICE_DESC,
    sort: Common.SORT_QUERY_PRICE_DESC,
  },
  {
    title: Common.SORT_TITLE_PRICE_ASC,
    sort: Common.SORT_QUERY_PRICE_ASC,
  },
];

const Projects: React.FC = () => {

  const [searchParams, setSearchParams] = useState<SearchParams>(initSearchParams);
  const [projectsData, setProjectsData] = useState<ProjectsData>(initProjectsData);

  const location = useLocation();
  const history = useHistory();

  useEffect(() => {
    let params: SearchParams = searchParams;

    if (location.search) {
      let page: number = searchParams.page;
      let sort: string = searchParams.sort;
      let tags: string = searchParams.tags;
      let locations: string = searchParams.locations;
      let contracts: string = searchParams.contracts;
      let positions: string = searchParams.positions;
      let industries: string = searchParams.industries;
      let keyword: string = searchParams.keyword;

      let paramsList: string[] = location.search.slice(1).split('&');
      paramsList.map((paramBase: string) => {
        let paramsBase: string[] = paramBase.split('=');
        let paramTitle: string = paramsBase[0];
        let paramItems: string = paramsBase[1];

        switch(paramTitle){
          case 'page':
            return page = Number(paramItems);
          case 'sort':
            return sort = paramItems;
          case 'tags':
            return tags = paramItems;
          case 'locations':
            return locations = paramItems;
          case 'contracts':
            return contracts = paramItems;
          case 'positions':
            return positions = paramItems;
          case 'industries':
            return industries = paramItems;
          case 'keyword':
            return keyword = paramItems;
          default:
            return null;
        }
      })
      params = {
        page: page,
        sort: sort,
        tags: tags,
        locations: locations,
        contracts: contracts,
        positions: positions,
        industries: industries,
        keyword: keyword,
      }
    }
    Axios.get(`${Common.API_ENDPOINT}search/index`, {
      params: params,
    })
    .then((res) => {
      setProjectsData(res.data);
    })
    .catch((res) => {
      console.log(res);
    });
  }, [searchParams]);

  window.scrollTo(0, 0);
  return (
    <div>
      <section className='pjt-list'>
        <h2 className='component-title'>案件一覧</h2>
        <h4>現在のページ（テスト用）：{projectsData.currentPage}</h4>
        <div className='pjt-sort-btn-container'>
          {
            SORT_LIST.map((sortHash: SortHash, index: number) => {
              return(
                <>
                  <Link
                    to={
                      handleLocationSearch(
                        projectsData.searchParams.tags,
                        projectsData.searchParams.locations,
                        projectsData.searchParams.contracts,
                        projectsData.searchParams.positions,
                        projectsData.searchParams.industries,
                        projectsData.searchParams.keyword,
                        Common.FIRST_PAGE,
                        sortHash.sort,
                      )
                    }
                    onClick={(e) => {
                      history.push(
                        handleLocationSearch(
                          projectsData.searchParams.tags,
                          projectsData.searchParams.locations,
                          projectsData.searchParams.contracts,
                          projectsData.searchParams.positions,
                          projectsData.searchParams.industries,
                          projectsData.searchParams.keyword,
                          Common.FIRST_PAGE,
                          sortHash.sort,
                        )
                      )
                      setSearchParams({
                        ...searchParams,
                        page: Common.FIRST_PAGE,
                        sort: sortHash.sort,
                      })
                    }}
                    key={`sortKey${index}`}
                  >
                    {sortHash.title}
                  </Link>
                </>
              );
            })
          }
        </div>
        <ul>
          {
            projectsData.pjtList.map((pjt: ProjectHash, indexPjt: number) => {
              const minPriceStr: string = pjt.min_price === 0 || null ? '' : String(pjt.min_price.toLocaleString());
              const maxPriceStr: string = String(pjt.max_price.toLocaleString());
              return (
                <li className='pjt-box' key={`pjt${indexPjt}`}>
                  <Link to={`/project/${pjt.id}`}
                    className='pjt-link'
                    key={`pjtLink${indexPjt}`}
                  >
                    <h2 className='pjt-title'>{pjt.title}</h2>
                  </Link>
                  <div className='pjt-summary'>
                    <ul>
                      <li className='pjt-price' key={`pjtPrice${indexPjt}`}>
                        単価：{minPriceStr}~{maxPriceStr}{pjt.price_unit}
                      </li>
                      <li className='pjt-location' key={`pjtLocation${indexPjt}`}>
                        勤務地：{pjt.location_name}
                      </li>
                      <li className={`pjt-tags${indexPjt}`}>
                        {tagList(pjt)}
                        <li className='pjt-updated-at' key={`pjtUpdatedAt${indexPjt}`}>
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
        <div className='paging-btn-container'>
          {
            [...Array(projectsData.totalPages)].map((_, index: number) => {
              let page: number = index + 1;
              return(
                <>
                  <Link
                    to={
                      handleLocationSearch(
                        projectsData.searchParams.tags,
                        projectsData.searchParams.locations,
                        projectsData.searchParams.contracts,
                        projectsData.searchParams.positions,
                        projectsData.searchParams.industries,
                        projectsData.searchParams.keyword,
                        page,
                        projectsData.searchParams.sort
                      )
                    }
                    onClick={(e) => {
                      history.push(
                        handleLocationSearch(
                          projectsData.searchParams.tags,
                          projectsData.searchParams.locations,
                          projectsData.searchParams.contracts,
                          projectsData.searchParams.positions,
                          projectsData.searchParams.industries,
                          projectsData.searchParams.keyword,
                          page,
                          projectsData.searchParams.sort
                        )
                      )
                      setSearchParams({
                        ...searchParams,
                        page: page,
                      })
                    }}
                  >
                    {page}
                  </Link>
                </>
              );
            })
          }
        </div>
      </section>
    </div>
  )
}

// URL作成メソッド
const handleLocationSearch = (
  tags: string,
  locations: string,
  contracts: string,
  positions: string,
  industries: string,
  keyword: string,
  page: number,
  sort: string
  ) => {
  const locationSearch: string = `/projects?tags=${tags}&locations=${locations}&contracts=${contracts}&positions=${positions}&industries=${industries}&keyword=${keyword}&page=${page}&sort=${sort}`
  return locationSearch
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
              className='pjt-tag-name'
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