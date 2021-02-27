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
          {/* <img src="https://image.shutterstock.com/image-photo/smiling-bearded-african-man-using-600w-573112123.jpg" alt="main-image"/> */}
        </section>
        <SearchBox />
        <Link to='/projects' className='latest-pjts-search-btn'>新着案件を見る</Link>
      </section>
      <footer>
        <small>© 2021 Bebright Japan</small>
      </footer>
    </>
  )
}

export default Home;