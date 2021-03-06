import React from 'react';
import SearchBox from './SearchBox';
import { Link } from 'react-router-dom';

const Home: React.FC = () => {
  return (
    <>
      <section className='home'>
        <header className='header'>
        </header>
        <section className='main-img'>
        </section>
        <SearchBox />
        <Link to='/projects' className='latest-pjts-search-btn'>新着案件を見る</Link>
      </section>
    </>
  )
}

export default Home;