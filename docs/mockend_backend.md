```mermaid
erDiagram
    User ||--o{ Transaction : has
    User ||--|| Wallet : owns
    User ||--o{ Transaction : receives

    User {
        int id
        string name
        string email
        string password
        string photoUrl
        string thumbnailUrl
        datetime createdAt
    }

    Wallet {
        int id
        float balance
        string currency
        datetime updatedAt
        int userId FK
    }

    Transaction {
        int id
        float amount
        string description
        string status
        datetime createdAt
        int userId FK
        int recipientId FK
    }
```

User has:
- One Wallet (1:1)
- Many Transactions as sender (1:N)
- Many Transactions as recipient via recipientId (1:N)
- Transaction includes both userId (sender) and recipientId (receiver)
- Wallet belongs to one User