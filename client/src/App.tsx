import React from 'react';
import './App.scss';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import Navigation from './components/Navigation'
import Home from './components/Home'
import Projects from './components/Projects'
import Project from './components/Project'
import * as Common from './constants/common';
import { Helmet } from 'react-helmet';

const App: React.FC = () => {
  return (
    <div className='App'>
      <Helmet>
        <meta charSet='utf-8' />
        <title>{Common.WEBSITE_NAME}</title>
        <link rel='canonical' href='' />
        <meta name='description' content='Description for techies guild' />
      </Helmet>
      <Router>
        <Navigation/>
        <Switch>
          <Route exact path='/' component={Home} />
          <Route exact path='/projects' component={Projects} />
          <Route exact path='/project/:pjtId' component={Project} />
        </Switch>
      </Router>
    </div>
  );
}

export default App;