class Category < ActiveHash::Base
  self.data = [
    { id: 0, name: '---' },
    { id: 1, name: 'トップス' },
    { id: 2, name: 'ボトムス' },
    { id: 3, name: 'セットアップ' },
    { id: 4, name: 'アウター/ジャケット' },
    { id: 5, name: 'バッグ/小物/アクセサリー'},
    { id: 6, name: 'シューズ'}
  ]
end