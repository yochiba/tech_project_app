// import React from 'react';
// import ReactDOM from 'react-dom';
// import './index.scss';
// import App from './App';
// import reportWebVitals from './reportWebVitals';
// import { createStore, applyMiddleware } from 'redux';
// import { Provider } from 'react-redux';
// import thunk from 'redux-thunk';
// import rootReducer from './reducers';

// // use applyMiddleware to add the thunk middleware to the store
// const store = createStore(rootReducer, applyMiddleware(thunk));

// ReactDOM.render(
//   <Provider store={store}>
//     <App />
//   </Provider>,
//   document.getElementById('root')
// );

// // If you want to start measuring performance in your app, pass a function
// // to log results (for example: reportWebVitals(console.log))
// // or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
// reportWebVitals();

import React from 'react';
import ReactDOM from 'react-dom';
import './index.scss';
import App from './App';
import reportWebVitals from './reportWebVitals';

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
