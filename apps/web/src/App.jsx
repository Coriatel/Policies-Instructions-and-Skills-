import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import ProtectedRoute from './guards/ProtectedRoute';
import Login from './pages/Login';
import Register from './pages/Register';
import Dashboard from './pages/Dashboard';
import ContentList from './pages/ContentList';
import ContentCreate from './pages/ContentCreate';
import ContentEdit from './pages/ContentEdit';
import UserList from './pages/UserList';
import NotFound from './pages/NotFound';

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />

          <Route
            path="/dashboard"
            element={
              <ProtectedRoute>
                <Dashboard />
              </ProtectedRoute>
            }
          />

          <Route
            path="/content"
            element={
              <ProtectedRoute>
                <ContentList />
              </ProtectedRoute>
            }
          />

          <Route
            path="/content/new"
            element={
              <ProtectedRoute>
                <ContentCreate />
              </ProtectedRoute>
            }
          />

          <Route
            path="/content/:id/edit"
            element={
              <ProtectedRoute>
                <ContentEdit />
              </ProtectedRoute>
            }
          />

          <Route
            path="/users"
            element={
              <ProtectedRoute requiredRole="ADMIN">
                <UserList />
              </ProtectedRoute>
            }
          />

          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route path="*" element={<NotFound />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;
