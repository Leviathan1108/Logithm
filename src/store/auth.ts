import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import { AuthUser, ApiResponse } from '@/types'

interface AuthState {
  user: AuthUser | null
  isLoading: boolean
  isAuthenticated: boolean
  login: (email: string, password: string) => Promise<ApiResponse>
  register: (email: string, username: string, password: string, confirmPassword: string) => Promise<ApiResponse>
  logout: () => Promise<ApiResponse>
  checkAuth: () => Promise<ApiResponse>
  updateUser: (userData: Partial<AuthUser>) => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,
      isLoading: false,
      isAuthenticated: false,

      login: async (email: string, password: string) => {
        set({ isLoading: true })
        try {
          const response = await fetch('/api/auth/login', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ email, password }),
          })

          const data: ApiResponse<{ user: AuthUser }> = await response.json()

          if (data.success && data.data?.user) {
            set({
              user: data.data.user,
              isAuthenticated: true,
              isLoading: false,
            })
            return data
          } else {
            set({ isLoading: false })
            return data
          }
        } catch (error) {
          set({ isLoading: false })
          return {
            success: false,
            error: { message: 'Network error', statusCode: 500 }
          }
        }
      },

      register: async (email: string, username: string, password: string, confirmPassword: string) => {
        set({ isLoading: true })
        try {
          const response = await fetch('/api/auth/register', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ email, username, password, confirmPassword }),
          })

          const data: ApiResponse<{ user: AuthUser }> = await response.json()

          if (data.success && data.data?.user) {
            set({
              user: data.data.user,
              isAuthenticated: true,
              isLoading: false,
            })
            return data
          } else {
            set({ isLoading: false })
            return data
          }
        } catch (error) {
          set({ isLoading: false })
          return {
            success: false,
            error: { message: 'Network error', statusCode: 500 }
          }
        }
      },

      logout: async () => {
        set({ isLoading: true })
        try {
          const response = await fetch('/api/auth/logout', {
            method: 'POST',
          })

          const data: ApiResponse = await response.json()

          set({
            user: null,
            isAuthenticated: false,
            isLoading: false,
          })

          return data
        } catch (error) {
          set({
            user: null,
            isAuthenticated: false,
            isLoading: false,
          })
          return {
            success: false,
            error: { message: 'Network error', statusCode: 500 }
          }
        }
      },

      checkAuth: async () => {
        const { isAuthenticated } = get()
        if (isAuthenticated) {
          return { success: true, data: { user: get().user } }
        }

        set({ isLoading: true })
        try {
          const response = await fetch('/api/auth/me')
          const data: ApiResponse<{ user: AuthUser }> = await response.json()

          if (data.success && data.data?.user) {
            set({
              user: data.data.user,
              isAuthenticated: true,
              isLoading: false,
            })
            return data
          } else {
            set({
              user: null,
              isAuthenticated: false,
              isLoading: false,
            })
            return data
          }
        } catch (error) {
          set({
            user: null,
            isAuthenticated: false,
            isLoading: false,
          })
          return {
            success: false,
            error: { message: 'Network error', statusCode: 500 }
          }
        }
      },

      updateUser: (userData: Partial<AuthUser>) => {
        const currentUser = get().user
        if (currentUser) {
          set({
            user: { ...currentUser, ...userData }
          })
        }
      },
    }),
    {
      name: 'auth-storage',
      partialize: (state) => ({
        user: state.user,
        isAuthenticated: state.isAuthenticated,
      }),
    }
  )
)