import { Link } from 'react-router-dom';

const Navigation: React.FC = () => {
  return (
    <nav className='header-nav'>
      <ul>
        <li>
          <Link to='/' className='nav-link' key='navLinkHome'>
            Home
          </Link>
        </li>
        <li>
          <Link to='/projects' className='nav-link'  key='navLinkProjects'>
            Projects
          </Link>
        </li>
      </ul>
    </nav>
  )
}

export default Navigation