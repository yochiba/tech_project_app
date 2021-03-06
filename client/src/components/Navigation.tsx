import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faBars } from '@fortawesome/free-solid-svg-icons';

const Navigation: React.FC = () => {
  const [navFlg, setNavFlg] = useState<boolean>(false);

  const handleNavMenu = (logoFlg: boolean) => {
    let updatedNavFlg: boolean = false;
    // Logoクリック以外の場合
    if (!logoFlg) {
      updatedNavFlg = navFlg ? false : true;
    }
    setNavFlg(updatedNavFlg);
  }

  const navigationMenu = () => {
    return(
      <ul className='nav-menu-container' onClick={() => {handleNavMenu(false)}}>
        <li key='li-home'>
          <Link to='/' className='nav-link' onClick={() => {handleNavMenu(false)}} key='navLinkHome'>
            Home
          </Link>
        </li>
        <li key='li-projects'>
          <Link to='/projects' className='nav-link' onClick={() => {handleNavMenu(false)}}  key='navLinkProjects'>
            Projects
          </Link>
        </li>
      </ul>
    );
  }

  const navMenu = navFlg ? navigationMenu() : null;

  return (
    <nav>
      <div className='nav-bar'>
        <Link to='/' className='main-logo' onClick={() => {handleNavMenu(true)}}>
          LOGO(仮)
        </Link>
        <button className='hamburger-box' onClick={() => {handleNavMenu(false)}}>
          <FontAwesomeIcon icon={faBars} className='hamburger-bars' />
        </button>
      </div>
      {navMenu}
    </nav>
  )
}

export default Navigation