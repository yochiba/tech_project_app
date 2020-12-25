import React from 'react';
import SearchBox from './SearchBox';

const Home: React.FC = () => {
  return (
    <section className='home'>
      <header className='header'>
        <SearchBox />
      </header>
    </section>
  )
}

export default Home