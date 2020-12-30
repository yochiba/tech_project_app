import React from 'react';

type searchHash = {
  tag_list: string[];
}

const SearchBox: React.FC = () => {
  return(
    <>
      <h2>検索ボックス</h2>
      <form className='search-form'>
        {/* FIXME ここに検索タイプのタブ追加 */}
        <label htmlFor='pjt-keyword-input'>
          キーワード検索
          <input type='text' name='keyword' id='pjt-keyword-input'/>
        </label>
        <input type='submit' value='検索'/>
      </form>
    </>
  );
}

// FIXME　タグ、ロケーション、ポジション、業界、最高単価で検索できるようにする
const searchBySkills = () => {
  return(
    <>
      <label htmlFor=''>
        <input type='checkbox'/>
      </label>
    </>
  );
}

export default SearchBox;