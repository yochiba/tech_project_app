import React, {useState, useEffect} from 'react';
import Axios from 'axios';
import * as Common from '../constants/common';
import { Link, useHistory } from 'react-router-dom';

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

  return(
    <>
      <h2>案件を探す</h2>
      <form className='search-form'>
        <div className='sort-option-checkbox-container'>
          <div className='sort-checkbox-box'>
            {
              SORT_LIST.map((sortHash: SortHash, index: number) => {              
                let checked: boolean = searchParams.sort === sortHash.sort ? true : false;
                return(
                  <>
                    <label htmlFor='pjt-sort-input' key={`sortLabel${index}`}>
                      <input
                        className='pjt-sort-input'
                        type='radio'
                        checked={checked}
                        value={sortHash.sort}
                        name='sort'
                        id='pjt-sort-input'
                        onChange={(e) => {
                          setSearchParams(
                            {
                              ...searchParams,
                              sort: e.target.value,
                            }
                          );
                        }}
                        key={`sortInput${index}`}
                      />
                      {sortHash.title}
                    </label>
                  </>
                );
              })
            }
          </div>
          <div className='order-checkbox-box'>
            {
              ORDER_LIST.map((orderHash: OrderHash, index: number) => {              
                let checked: boolean = searchParams.order === orderHash.order ? true : false;
                return(
                  <>
                    <label htmlFor='pjt-order-input' key={`orderLabel${index}`}>
                      <input
                        className='pjt-order-input'
                        type='radio'
                        checked={checked}
                        value={orderHash.order}
                        name='order'
                        id='pjt-order-input'
                        onChange={(e) => {
                          setSearchParams(
                            {
                              ...searchParams,
                              order: e.target.value,
                            }
                          );
                        }}
                        key={`orderInput${index}`}
                      />
                      {orderHash.title}
                    </label>
                  </>
                );
              })
            }
          </div>
        </div>
        <div className='search-tab search-tag-tab'>
          <h3>タグで探す</h3>
          {
            checkBoxItemList.tagList.map((tag: TagHash, index: number) => {
              return(
                <label htmlFor='pjt-tag-input' key={`tagLabelKey${index}`}>
                  <input
                    type='checkbox'
                    value={tag.tag_name_search}
                    name='tags'
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
                  {tag.tag_name}
                </label>
              );
            })
          }
        </div>
        <div className='search-tab search-location-tab'>
          <h3>勤務地で探す</h3>
          {
            checkBoxItemList.locationList.map((location: LocationHash, index: number) => {
              return(
                <label htmlFor='pjt-location-input' key={`locationLabelKey${index}`}>
                  <input
                    type='checkbox'
                    value={location.location_name}
                    name='locations'
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
                  {location.location_name}
                </label>
              );
            })
          }
        </div>
        <div className='search-tab search-contract-tab'>
          <h3>契約形態で探す</h3>
          {
            checkBoxItemList.contractList.map((contract: ContractHash, index: number) => {
              return(
                <label htmlFor='pjt-contract-input' key={`contractLabelKey${index}`}>
                  <input
                    type='checkbox'
                    value={contract.contract_name}
                    name='contracts'
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
                  {contract.contract_name}
                </label>
              );
            })
          }
        </div>
        <div className='search-tab search-position-tab'>
          <h3>ポジションで探す</h3>
          {
            checkBoxItemList.positionList.map((position: PositionHash, index: number) => {
              return(
                <label htmlFor='pjt-position-input' key={`positionLabelKey${index}`}>
                  <input
                    type='checkbox'
                    value={position.position_name_search}
                    name='positions'
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
                  {position.position_name}
                </label>
              );
            })
          }
        </div>
        <div className='search-tab search-industry-tab'>
          <h3>業界で探す</h3>
          {
            checkBoxItemList.industryList.map((industry: IndustryHash, index: number) => {
              return(
                <label htmlFor='pjt-industry-input' key={`industryLabelKey${index}`}>
                  <input
                    type='checkbox'
                    value={industry.industry_name_search}
                    name='industries'
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
                  {industry.industry_name}
                </label>
              );
            })
          }
        </div>
        {/* <div className='search-keyword'>
          <label htmlFor='pjt-keyword-input'>
            キーワード検索
            <input
              type='text'
              name='keyword'
              id='pjt-keyword-input'
            />
          </label>
        </div> */}
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
    </>
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