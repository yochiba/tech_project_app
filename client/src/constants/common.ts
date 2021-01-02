// API エンドポイント
export const API_ENDPOINT: string = process.env.REACT_APP_API_ENDPOINT!;

export const SORT_TITLE_LATEST: string = '新着順';
export const SORT_QUERY_LATEST: string = 'created_at DESC';

export const SORT_TITLE_OLDEST: string = '古い順';
export const SORT_QUERY_OLDEST: string = 'created_at ASC';

export const SORT_TITLE_PRICE_DESC: string = '単価が高い順';
export const SORT_QUERY_PRICE_DESC: string = 'max_price DESC';

export const SORT_TITLE_PRICE_ASC: string = '単価が低い順';
export const SORT_QUERY_PRICE_ASC: string = 'max_price ASC';