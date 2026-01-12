# /add-react-table

**Workspace Workflow** - הוספת טבלת נתונים חדשה

## מתי להשתמש
- הצגת רשימת נתונים בטבלה
- CRUD על resource עם UI

## Input נדרש
- **Resource name**: שם ה-resource (e.g., "users")
- **Columns**: אילו עמודות להציג
- **Features**: sorting? filtering? search? pagination?
- **Actions**: אילו פעולות שורה (edit, delete, view)

---

## הצעדים

### 1. יצירת Table Component
`/apps/web/src/components/{Resource}Table.jsx`

```jsx
import { useState, useMemo } from 'react';
import { useTranslation } from 'react-i18next';
import PropTypes from 'prop-types';
import './styles/{resource}-table.scss';

function {Resource}Table({
  data = [],
  loading = false,
  onEdit,
  onDelete,
  onView,
}) {
  const { t } = useTranslation();
  const [sortField, setSortField] = useState('createdAt');
  const [sortDirection, setSortDirection] = useState('desc');
  const [searchTerm, setSearchTerm] = useState('');

  // Filter and sort data
  const processedData = useMemo(() => {
    let result = [...data];

    // Search filter
    if (searchTerm) {
      const term = searchTerm.toLowerCase();
      result = result.filter(item =>
        item.name?.toLowerCase().includes(term) ||
        item.email?.toLowerCase().includes(term)
      );
    }

    // Sort
    result.sort((a, b) => {
      const aVal = a[sortField];
      const bVal = b[sortField];
      const direction = sortDirection === 'asc' ? 1 : -1;

      if (aVal < bVal) return -1 * direction;
      if (aVal > bVal) return 1 * direction;
      return 0;
    });

    return result;
  }, [data, searchTerm, sortField, sortDirection]);

  const handleSort = (field) => {
    if (sortField === field) {
      setSortDirection(prev => prev === 'asc' ? 'desc' : 'asc');
    } else {
      setSortField(field);
      setSortDirection('asc');
    }
  };

  const SortIcon = ({ field }) => {
    if (sortField !== field) return <span className="sort-icon">↕</span>;
    return (
      <span className="sort-icon active">
        {sortDirection === 'asc' ? '↑' : '↓'}
      </span>
    );
  };

  if (loading) {
    return (
      <div className="{resource}-table__loading">
        {t('common.loading')}
      </div>
    );
  }

  if (!data.length) {
    return (
      <div className="{resource}-table__empty">
        <p>{t('{resource}.emptyState')}</p>
      </div>
    );
  }

  return (
    <div className="{resource}-table">
      {/* Search */}
      <div className="{resource}-table__toolbar">
        <input
          type="search"
          className="{resource}-table__search"
          placeholder={t('common.search')}
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>

      {/* Table */}
      <table className="{resource}-table__table">
        <thead>
          <tr>
            <th onClick={() => handleSort('name')}>
              {t('{resource}.columns.name')}
              <SortIcon field="name" />
            </th>
            <th onClick={() => handleSort('email')}>
              {t('{resource}.columns.email')}
              <SortIcon field="email" />
            </th>
            <th onClick={() => handleSort('status')}>
              {t('{resource}.columns.status')}
              <SortIcon field="status" />
            </th>
            <th onClick={() => handleSort('createdAt')}>
              {t('{resource}.columns.createdAt')}
              <SortIcon field="createdAt" />
            </th>
            <th className="{resource}-table__actions-header">
              {t('common.actions')}
            </th>
          </tr>
        </thead>
        <tbody>
          {processedData.map((item) => (
            <tr key={item.id}>
              <td>{item.name}</td>
              <td>
                <span dir="ltr">{item.email}</span>
              </td>
              <td>
                <StatusBadge status={item.status} />
              </td>
              <td>
                <span dir="ltr">
                  {new Date(item.createdAt).toLocaleDateString('he-IL')}
                </span>
              </td>
              <td className="{resource}-table__actions">
                {onView && (
                  <button
                    onClick={() => onView(item)}
                    className="btn btn--icon"
                    title={t('common.view')}
                  >
                    👁
                  </button>
                )}
                {onEdit && (
                  <button
                    onClick={() => onEdit(item)}
                    className="btn btn--icon"
                    title={t('common.edit')}
                  >
                    ✏️
                  </button>
                )}
                {onDelete && (
                  <button
                    onClick={() => onDelete(item)}
                    className="btn btn--icon btn--danger"
                    title={t('common.delete')}
                  >
                    🗑
                  </button>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* Results count */}
      <div className="{resource}-table__footer">
        {t('common.showingResults', {
          count: processedData.length,
          total: data.length,
        })}
      </div>
    </div>
  );
}

// Status badge component
function StatusBadge({ status }) {
  const { t } = useTranslation();
  const statusMap = {
    active: { class: 'success', label: t('status.active') },
    inactive: { class: 'warning', label: t('status.inactive') },
    pending: { class: 'info', label: t('status.pending') },
    blocked: { class: 'danger', label: t('status.blocked') },
  };

  const { class: className, label } = statusMap[status] || {
    class: 'default',
    label: status,
  };

  return (
    <span className={`status-badge status-badge--${className}`}>
      {label}
    </span>
  );
}

{Resource}Table.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.string.isRequired,
    name: PropTypes.string,
    email: PropTypes.string,
    status: PropTypes.string,
    createdAt: PropTypes.string,
  })),
  loading: PropTypes.bool,
  onEdit: PropTypes.func,
  onDelete: PropTypes.func,
  onView: PropTypes.func,
};

export default {Resource}Table;
```

### 2. יצירת Styles
`/apps/web/src/components/styles/{resource}-table.scss`

```scss
.{resource}-table {
  direction: rtl;

  &__toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-block-end: 16px;
  }

  &__search {
    padding: 8px 12px;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    width: 300px;
    text-align: start;

    &::placeholder {
      color: var(--text-muted);
    }
  }

  &__table {
    width: 100%;
    border-collapse: collapse;
    background: var(--bg-white);
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);

    th, td {
      padding: 12px 16px;
      text-align: start;
      border-block-end: 1px solid var(--border-color);
    }

    th {
      background: var(--bg-light);
      font-weight: 600;
      cursor: pointer;
      user-select: none;

      &:hover {
        background: var(--bg-hover);
      }
    }

    tbody tr {
      &:hover {
        background: var(--bg-hover);
      }

      &:last-child td {
        border-block-end: none;
      }
    }
  }

  &__actions-header {
    width: 120px;
    text-align: center !important;
  }

  &__actions {
    text-align: center;
    white-space: nowrap;

    .btn {
      margin-inline: 4px;
    }
  }

  &__footer {
    margin-block-start: 16px;
    color: var(--text-muted);
    font-size: 0.875rem;
  }

  &__loading,
  &__empty {
    padding: 48px;
    text-align: center;
    color: var(--text-muted);
    background: var(--bg-light);
    border-radius: 8px;
  }
}

// Sort icon
.sort-icon {
  margin-inline-start: 4px;
  opacity: 0.3;

  &.active {
    opacity: 1;
    color: var(--primary);
  }
}

// Status badges
.status-badge {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 500;

  &--success {
    background: var(--success-light);
    color: var(--success);
  }

  &--warning {
    background: var(--warning-light);
    color: var(--warning);
  }

  &--info {
    background: var(--info-light);
    color: var(--info);
  }

  &--danger {
    background: var(--danger-light);
    color: var(--danger);
  }

  &--default {
    background: var(--bg-light);
    color: var(--text-muted);
  }
}

// Buttons
.btn {
  &--icon {
    padding: 4px 8px;
    background: none;
    border: none;
    cursor: pointer;
    border-radius: 4px;

    &:hover {
      background: var(--bg-hover);
    }
  }

  &--danger:hover {
    background: var(--danger-light);
  }
}
```

### 3. הוספת תרגומים
`/apps/web/src/locales/he.json`

```json
{
  "{resource}": {
    "title": "{Resource}",
    "emptyState": "אין נתונים להצגה",
    "columns": {
      "name": "שם",
      "email": "אימייל",
      "status": "סטטוס",
      "createdAt": "תאריך יצירה"
    }
  },
  "status": {
    "active": "פעיל",
    "inactive": "לא פעיל",
    "pending": "ממתין",
    "blocked": "חסום"
  },
  "common": {
    "search": "חיפוש...",
    "actions": "פעולות",
    "view": "צפייה",
    "edit": "עריכה",
    "delete": "מחיקה",
    "loading": "טוען...",
    "showingResults": "מציג {{count}} מתוך {{total}} תוצאות"
  }
}
```

### 4. שימוש בטבלה
```jsx
import { useState, useEffect } from 'react';
import {Resource}Table from '../components/{Resource}Table';

function {Resource}Page() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const res = await fetch('/api/v1/{resource}');
      const json = await res.json();
      setData(json.data);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = (item) => {
    // Navigate to edit page or open modal
  };

  const handleDelete = async (item) => {
    if (!confirm('האם למחוק?')) return;

    await fetch(`/api/v1/{resource}/${item.id}`, { method: 'DELETE' });
    fetchData();
  };

  return (
    <div className="page">
      <h1>{t('{resource}.title')}</h1>
      <{Resource}Table
        data={data}
        loading={loading}
        onEdit={handleEdit}
        onDelete={handleDelete}
      />
    </div>
  );
}
```

---

## Checklist

- [ ] Table component created
- [ ] Styles created (RTL-ready)
- [ ] Translations added (he + en)
- [ ] Page uses the table
- [ ] Sorting works
- [ ] Search works
- [ ] Actions work
- [ ] RTL tested

---

**Output**: Working table component with sorting, search, and actions
