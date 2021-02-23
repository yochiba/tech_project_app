import React from 'react';
import SearchBox from './SearchBox';
import { Link } from 'react-router-dom';

const Home: React.FC = () => {
  return (
    <section className='home'>
      <header className='header'>
      </header>
      <SearchBox />
      <Link to='/projects'>新着案件</Link>
    </section>
  )
}

export default Home;