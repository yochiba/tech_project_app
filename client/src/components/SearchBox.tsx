import React, {useState, useEffect} from 'react';
import Axios from 'axios';
import * as Common from '../constants/common';
import { Link, useHistory } from 'react-router-dom';
import Slider from "react-slick";
import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick-theme.css";

type CheckBoxItem = {
  status: number;
  result: string;
  tagList: TagHash[];
  locationList: LocationHash[];
  contractList: ContractHash[];
  positionList: PositionHash[];
  industryList: IndustryHash[];
}

type TagHash = {
  id: number;
  tag_name: string;
  tag_name_search: string;
  tag_type_name: string;
  tag_type_id: number;
}

type LocationHash = {
  id: number;
  location_name: string;
}

type ContractHash = {
  id: number;
  contract_name: string;
}

type PositionHash = {
  id: number;
  position_name: string;
  position_name_search: string;
}

type IndustryHash = {
  id: number;
  industry_name: string;
  industry_name_search: string;
}

const initCheckBoxItem: CheckBoxItem = {
  status: 204,
  result: 'NO CONTENT',
  tagList: [],
  locationList: [],
  contractList: [],
  positionList: [],
  industryList: [],
}

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

// type SortHash = {
//   title: string;
//   sort: string;
// }

// const SORT_LIST: SortHash[] = [
//   {
//     title: Common.TITLE_UPDATED_AT,
//     sort: Common.SORT_UPDATED_AT,
//   },
//   {
//     title: Common.TITLE_PRICE,
//     sort: Common.SORT_PRICE,
//   },
// ];

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

const SearchBox: React.FC = () => {
  const [checkBoxItemList, setCheckBoxItemList] = useState<CheckBoxItem>(initCheckBoxItem);
  const [searchParams, setSearchParams] = useState<SearchParams>(initSearchParams);

  useEffect(() => {
    Axios.get(`${Common.API_ENDPOINT}search/checkbox-items`)
    .then((res) => {
      setCheckBoxItemList(res.data);
    })
    .catch((res) => {
      console.log(res);
    });
  }, [checkBoxItemList.status])

  const history = useHistory();

  const slickSettings = {
    dots: true,
    infinite: true,
    speed: 10,
    slidesToShow: 1,
    slidesToScroll: 1
  };

  // タグ検索
  const tagSearchTab = () => {
    if (checkBoxItemList.tagList.length > 0) {
      return(
        <div className='search-tab search-tag-tab'>
          <h3 className='search-tab-title'>タグで探す</h3>
          <div className='search-labels-box'>
            {
              checkBoxItemList.tagList.map((tag: TagHash, index: number) => {
                return(
                  <label
                    className='search-label'
                    htmlFor='pjt-tag-input'
                    key={`tagLabelKey${index}`}
                  >
                    <input
                      type='checkbox'
                      value={tag.tag_name_search}
                      name='tags'
                      className='tag-input'
                      id='pjt-tag-input'
                      onChange={(e) => {
                        let tags: string = searchParams.tags;
                        let tagList: string[] = tags === '' ? [] : tags.split(',');
                        if (!tagList.includes(e.target.value)) {
                          tagList.push(e.target.value);
                          tags = tagList.join(',');
                        }
                        setSearchParams({...searchParams,tags: tags});
                      }}
                      key={`tagInputKey${index}`}
                    />
                    <h4 className='tag-name'>{tag.tag_name}</h4>
                  </label>
                );
              })
            }
          </div>
        </div>
      );
    } else {
      return null;
    }
  }

  // 勤務地検索
  const locationSearchTab = () => {
    if (checkBoxItemList.locationList.length > 0) {
      return(
        <div className='search-tab search-location-tab'>
          <h3 className='search-tab-title'>勤務地で探す</h3>
          <div className='search-labels-box'>
            {
              checkBoxItemList.locationList.map((location: LocationHash, index: number) => {
                return(
                  <label
                    className='search-label'
                    htmlFor='pjt-location-input'
                    key={`locationLabelKey${index}`}
                  >
                    <input
                      type='checkbox'
                      value={location.location_name}
                      name='locations'
                      className='tag-input'
                      id='pjt-location-input'
                      onChange={(e) => {
                        let locations: string = searchParams.locations;
                        let locationList: string[] = locations === '' ? [] : locations.split(',');
                        if (!locationList.includes(e.target.value)) {
                          locationList.push(e.target.value);
                          locations = locationList.join(',');
                        }
                        setSearchParams({...searchParams,locations: locations});
                      }}
                      key={`locationInputKey${index}`}
                    />
                    <h4 className='tag-name'>{location.location_name}</h4>
                  </label>
                );
              })
            }
          </div>
        </div>
      );
    } else {
      return null;
    }
  }

  // 契約形態検索
  const contractSearchTab = () => {
    if (checkBoxItemList.contractList.length > 0) {
      return(
        <div className='search-tab search-contract-tab'>
          <h3 className='search-tab-title'>契約形態で探す</h3>
          <div className='search-labels-box'>
            {
              checkBoxItemList.contractList.map((contract: ContractHash, index: number) => {
                return(
                  <label
                    className='search-label'
                    htmlFor='pjt-contract-input'
                    key={`contractLabelKey${index}`}
                  >
                    <input
                      type='checkbox'
                      value={contract.contract_name}
                      name='contracts'
                      className='tag-input'
                      id='pjt-contract-input'
                      onChange={(e) => {
                        let contracts: string = searchParams.contracts;
                        let contractList: string[] = contracts === '' ? [] : contracts.split(',');
                        if (!contractList.includes(e.target.value)) {
                          contractList.push(e.target.value);
                          contracts = contractList.join(',');
                        }
                        setSearchParams({...searchParams,contracts: contracts});
                      }}
                      key={`contractInputKey${index}`}
                    />
                    <h4 className='tag-name'>{contract.contract_name}</h4>
                  </label>
                );
              })
            }
          </div>
        </div>
      );
    } else {
      return null;
    }
  }

  // ポジション検索
  const positionSearchTab = () => {
    if (checkBoxItemList.positionList.length > 0) {
      return(
        <div className='search-tab search-position-tab'>
          <h3 className='search-tab-title'>ポジションで探す</h3>
          <div className='search-labels-box'>
            {
              checkBoxItemList.positionList.map((position: PositionHash, index: number) => {
                return(
                  <label
                    className='search-label'
                    htmlFor='pjt-position-input'
                    key={`positionLabelKey${index}`}
                  >
                    <input
                      type='checkbox'
                      value={position.position_name_search}
                      name='positions'
                      className='tag-input'
                      id='pjt-position-input'
                      onChange={(e) => {
                        let positions: string = searchParams.positions;
                        let positionList: string[] = positions === '' ? [] : positions.split(',');
                        if (!positionList.includes(e.target.value)) {
                          positionList.push(e.target.value);
                          positions = positionList.join(',');
                        }
                        setSearchParams({...searchParams,positions: positions});
                      }}
                      key={`positionInputKey${index}`}
                    />
                    <h4 className='tag-name'>{position.position_name}</h4>
                  </label>
                );
              })
            }
          </div>
        </div>
      );
    } else {
      return null;
    }
  }

  // 業界検索
  const industrySearchTab = () => {
    if (checkBoxItemList.industryList.length > 0) {
      return(
        <div className='search-tab search-industry-tab'>
          <h3 className='search-tab-title'>業界で探す</h3>
          <div className='search-labels-box'>
            { 
              checkBoxItemList.industryList.map((industry: IndustryHash, index: number) => {
                return(
                  <label
                    className='search-label'
                    htmlFor='pjt-industry-input'
                    key={`industryLabelKey${index}`}
                  >
                    <input
                      type='checkbox'
                      value={industry.industry_name_search}
                      name='industries'
                      className='tag-input'
                      id='pjt-industry-input'
                      onChange={(e) => {
                        let industries: string = searchParams.industries;
                        let industryList: string[] = industries === '' ? [] : industries.split(',');
                        if (!industryList.includes(e.target.value)) {
                          industryList.push(e.target.value);
                          industries = industryList.join(',');
                        }
                        setSearchParams({...searchParams,industries: industries});
                      }}
                      key={`industryInputKey${index}`}
                    />
                    <h4 className='tag-name'>{industry.industry_name}</h4>
                  </label>
                );
              })
            }
          </div>
        </div>
       );
    } else {
      return null;
    }
  }

  return(
    <section className='search-box'>
      <h2>案件を探す</h2>
      {/* <div className='search-keyword'>
        <label htmlFor='pjt-keyword-input'>
          タグ検索
        <input
          type='text'
          name='keyword'
          id='pjt-keyword-input'
          onChange={}
        />
        </label>
      </div> */}
      <form className='search-form'>
        <Slider {...slickSettings} className='search-tab-slider'>
          {/* タグ検索 */}
          {tagSearchTab()}
          {/* 勤務地検索 */}
          {locationSearchTab()}
          {/* 契約形態検索 */}
          {contractSearchTab()}
          {/* ポジション検索 */}
          {positionSearchTab()}
          {/* 業界検索 */}
          {industrySearchTab()}
        </Slider>
        <Link
          to={
            handleLocationSearch(
              searchParams.tags,
              searchParams.locations,
              searchParams.contracts,
              searchParams.positions,
              searchParams.industries,
              searchParams.keyword,
              searchParams.sort,
              searchParams.order,
            )
          }
          className='search-btn'
          onClick={() => history.push(
            handleLocationSearch(
              searchParams.tags,
              searchParams.locations,
              searchParams.contracts,
              searchParams.positions,
              searchParams.industries,
              searchParams.keyword,
              searchParams.sort,
              searchParams.order,
            )
          )}
        >
          検索
        </Link>
      </form>
    </section>
  );
}

const handleLocationSearch = (
  tags: string,
  locations: string,
  contracts: string,
  positions: string,
  industries: string,
  keyword: string,
  sort: string,
  order: string,
  ) => {
  let locationSearch: string = '/projects?';
  locationSearch = locationSearch.concat(`tags=${tags}`);
  locationSearch = locationSearch.concat(`&locations=${locations}`);
  locationSearch = locationSearch.concat(`&contracts=${contracts}`);
  locationSearch = locationSearch.concat(`&positions=${positions}`);
  locationSearch = locationSearch.concat(`&industries=${industries}`);
  locationSearch = locationSearch.concat(`&keyword=${keyword}`);
  locationSearch = locationSearch.concat(`&page=${Common.FIRST_PAGE}`);
  locationSearch = locationSearch.concat(`&sort=${sort}`);
  locationSearch = locationSearch.concat(`&order=${order}`);
  return locationSearch
}

export default SearchBox;