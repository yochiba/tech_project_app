# packages

## react appの作成
***
```
create-react-app client --typescript
```

## typescriptの設定を修正(必要な場合)
***
- package.jsonの"dependencies"配下
  - "typescript": "^4.0.3"→"typescript": "~4.0.3",
- tsconfig.jsonの"compilerOptions"配下
  - "jsx": "react-jsx"→"jsx": "react"
- yarn.lock削除
  - rm -f yarn.lock
- yarn.lockを再生成
  - yarn install


## tsconfig.jsonテンプレート
***
```
{
  "compilerOptions": {
    "target": "es5",
    "lib": [
      "dom",
      "dom.iterable",
      "esnext",
      "es2015",
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "react",
  },
  "include": [
    "src"
  ]
}
```

## webpackの導入
***
```
// webpack関連の導入
yarn add --dev webpack webpack-cli typescript ts-loader webpack-dev-server
yarn add react react-dom @types/react @types/react-dom

// SASSの導入
yarn add --dev sass style-loader sass-loader
```

## webpack.config.jsテンプレート
***
```
module.exports = {
  // モード値を production に設定すると最適化された状態で、
  // development に設定するとソースマップ有効でJSファイルが出力される
  mode: "development",

  // メインとなるJavaScriptファイル（エントリーポイント）
  entry: "./src/index.tsx",
  // ファイルの出力設定
  output: {
    //  出力ファイルのディレクトリ名
    path: `${__dirname}/dist`,
    // 出力ファイル名
    filename: "main.js"
  },
  module: {
    rules: [
      {
        // 拡張子 .ts もしくは .tsx の場合
        test: /\.tsx?$/,
        // TypeScript をコンパイルする
        use: "ts-loader"
      },
      {
        test: /\.scss/, 
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: {
              url: false,
              importLoaders: 2
            },
          },
          {
            loader: 'sass-loader',
          }
        ],
      },
    ]
  },
  // import 文で .ts や .tsx ファイルを解決するため
  resolve: {
    extensions: [".ts", ".tsx", ".js", ".json"]
  },
  // ES5(IE11等)向けの指定（webpack 5以上で必要）
  target: ["web", "es5"],
};
```

## Babelの導入
***

```
yarn add --dev @babel/core @babel/preset-env @babel/preset-react @babel/preset-typescript
yarn add --dev babel-loader@8.1.0
```

- babelの設定ファイルを作成
```
touch .babelrc
```

## .babelrcテンプレート
```
{
  "presets": [
    "@babel/preset-env",
    "@babel/preset-react",
    "@babel/preset-typescript"
  ]
}
```

## dotenv導入
***
```
yarn add --dev dotenv dotenv-cli
touch .env && touch .env.staging && touch .env.production
```

## react router導入
***
```
yarn add --dev react-router-dom @types/react-router-dom
```

## axiosの導入
***
```
yarn add --dev axios
```

## react-helmet(htmlのheadタグを設定するためのプラグイン)
***
```
yarn add --dev react-helmet @types/react-helmet
```

## font-awesomeの導入
***
```
yarn add --dev @fortawesome/fontawesome-svg-core
yarn add --dev @fortawesome/free-solid-svg-icons
yarn add --dev @fortawesome/react-fontawesome
```

## react-slickの導入
***
```
yarn add --dev react-slick @types/react-slick
yarn add --dev slick-carousel
```

## ドキュメントルート
***
```
/var/www/html/app/tech_project_app/dist
```

## 参考文献
***
- https://ics.media/entry/16329/#webpack-ts-react
- https://tech.playground.style/javascript/babel-webpack/
- https://dev.classmethod.jp/articles/react-dotenv-cli/
- https://github.com/nfl/react-helmet