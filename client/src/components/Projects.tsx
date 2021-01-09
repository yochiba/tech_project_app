import React, { useState, useEffect } from 'react';
import { 
  Link,
  Redirect,
  useLocation,
  useHistory,
} from 'react-router-dom';
import Axios from 'axios';
import * as Common from '../constants/common';

type SearchParams = {
  page: number;
  sort: string;
  order: string;
  tags: string;
  locations: string;
  contracts: string;
  positions: string;
  industries: string;
  keyword: string;
}

const initSearchParams = {
  page: Common.FIRST_PAGE,
  sort: Common.SORT_UPDATED_AT,
  order: Common.ORDER_DESC,
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
  order: string;
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
  sort: Common.SORT_UPDATED_AT,
  order: Common.ORDER_DESC,
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
    title: Common.TITLE_UPDATED_AT,
    sort: Common.SORT_UPDATED_AT,
  },
  {
    title: Common.TITLE_PRICE,
    sort: Common.SORT_PRICE,
  },
];

type OrderHash = {
  title: string;
  order: string;
}

const ORDER_LIST: OrderHash[] = [
  {
    title: Common.TITLE_DESC,
    order: Common.ORDER_DESC,
  },
  {
    title: Common.TITLE_ASC,
    order: Common.ORDER_ASC,
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
      let order: string = searchParams.order;
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
          case 'order':
            return order = paramItems;
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
        order: order,
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
      // FIXME 案件検索ヒット数が0の場合に以下の条件に入る
      if (res.data.totalPjtCount === 0) {
        console.log('NO CONTENT');
        <Redirect to='/' />
      }
      setProjectsData(res.data);
    })
    .catch((res) => {
      console.log(res);
    });
  }, [searchParams, location.search]);

  window.scrollTo(0, 0);
  return (
    <div className='projects'>
      <section className='pjt-list'>
        <h2 className='component-title'>案件一覧</h2>
        <h4>現在のページ（テスト用）：{projectsData.currentPage}</h4>
        <div className='sort-option-btn-container'>
          <div className='sort-btn-box'>
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
                          projectsData.searchParams.order,
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
                            projectsData.searchParams.order,
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
          <div className='order-btn-box'>
          {
            ORDER_LIST.map((orderHash: OrderHash, index: number) => {
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
                        projectsData.searchParams.sort,
                        orderHash.order,
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
                        projectsData.searchParams.sort,
                        orderHash.order,
                        )
                      )
                      setSearchParams({
                        ...searchParams,
                        page: Common.FIRST_PAGE,
                        order: orderHash.order,
                      })
                    }}
                    key={`orderKey${index}`}
                  >
                    {orderHash.title}
                  </Link>
                </>
              );
            })
          }
          </div>
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
                    <table>
                      <tr>
                        <th className='pjt-price'>
                          単価：
                        </th>
                        <td>
                          {minPriceStr}~{maxPriceStr}{pjt.price_unit}
                        </td>
                        <th className='pjt-location'>
                          勤務地：
                        </th>
                        <td>
                          {pjt.location_name}
                        </td>
                      </tr>
                      {tagList(pjt)}
                      <div className='pjt-updated-at'>
                        更新日：{dateFormat(pjt.updated_at, 'YYYY年MM月DD日')}
                      </div>
                    </table>
                  </div>
                  <h4 className='pjt-company'>From {pjt.company}</h4>
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
                        projectsData.searchParams.sort,
                        projectsData.searchParams.order,
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
                          projectsData.searchParams.sort,
                          projectsData.searchParams.order,
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
  sort: string,
  order: string
  ) => {
  let locationSearch: string = '/projects?';
  locationSearch = locationSearch.concat(`tags=${tags}`);
  locationSearch = locationSearch.concat(`&locations=${locations}`);
  locationSearch = locationSearch.concat(`&contracts=${contracts}`);
  locationSearch = locationSearch.concat(`&positions=${positions}`);
  locationSearch = locationSearch.concat(`&industries=${industries}`);
  locationSearch = locationSearch.concat(`&keyword=${keyword}`);
  locationSearch = locationSearch.concat(`&page=${page}`);
  locationSearch = locationSearch.concat(`&sort=${sort}`);
  locationSearch = locationSearch.concat(`&order=${order}`);
  return locationSearch
}

// タグ一覧
const tagList = (pjt: ProjectHash) => {

  let displayTagList: string [] = [];
  const tagNameList: string[] = pjt.tag_name_list;
  const positionNameList: string[] = pjt.position_name_list;
  const industryNameList: string[] = pjt.industry_name_list;

  if (tagNameList !== null) {
    displayTagList =  displayTagList.concat(tagNameList);
  }
  if (positionNameList !== null) {
    displayTagList = displayTagList.concat(positionNameList);
  }
  if (industryNameList !== null) {
    displayTagList = displayTagList.concat(industryNameList);
  }

  if (displayTagList.length !== 0) {
    return(
      <tr>
        <th>
          タグ：
        </th>
        <td>
          <ul>
            {displayTagList.map((tag_name: string, indexTagName: number) => {
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
        </td>
      </tr>
    )
  } else {
    return null;
  }
}

// 日付フォーマットメソッド
const dateFormat = (dateParam: Date, format: string) => {
  let date: Date = new Date(dateParam);

  let year: number = date.getFullYear();
  let month: number = date.getMonth() + 1;
  let day: number = date.getDate();

  format = format.replace(/YYYY/, year.toString());
  format = format.replace(/MM/, month.toString());
  format = format.replace(/DD/, day.toString());

  return format;
}

export default Projects