import React from 'react';
import './App.scss';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import Navigation from './components/Navigation'
import Home from './components/Home'
import Projects from './components/Projects'
import Project from './components/Project'

const App: React.FC = () => {
  return (
    <div className="App">
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