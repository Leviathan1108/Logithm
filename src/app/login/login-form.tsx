'use client'

import Link from 'next/link'
import { useRouter, useSearchParams } from 'next/navigation'
import { useState, useEffect, Suspense } from 'react'
import { useForm, validationRules } from '@/hooks/use-form'
import { Button } from '@/components/ui/Button'
import { Input } from '@/components/ui/Input'
import { Alert } from '@/components/ui/Alert'
import { useAuthStore } from '@/store/auth'
import { LoginCredentials } from '@/types'

function LoginForm() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const { login, isLoading, isAuthenticated } = useAuthStore()
  const [error, setError] = useState<string | null>(null)

  const form = useForm<LoginCredentials>({
    email: '',
    password: ''
  })

  const validationRulesForForm = {
    email: [
      validationRules.required('Email is required'),
      validationRules.email('Please enter a valid email')
    ],
    password: [
      validationRules.required('Password is required')
    ]
  }

  // Redirect if already authenticated
  useEffect(() => {
    if (isAuthenticated) {
      const redirectTo = searchParams.get('redirect') || '/dashboard'
      router.push(redirectTo)
    }
  }, [isAuthenticated, router, searchParams])

  // Show success message if redirected from signup
  useEffect(() => {
    const message = searchParams.get('message')
    if (message === 'signup-success') {
      setError(null)
    }
  }, [searchParams])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)

    const isValid = form.validate(validationRulesForForm)
    if (!isValid) {
      return
    }

    try {
      const result = await login(form.data.email, form.data.password)

      if (result.success) {
        const redirectTo = searchParams.get('redirect') || '/dashboard'
        router.push(redirectTo)
      } else {
        setError(result.error?.message || 'Login failed')
      }
    } catch (error) {
      setError('An unexpected error occurred. Please try again.')
    }
  }

  const handleFieldChange = (field: keyof LoginCredentials, value: string) => {
    form.setField(field, value)
    form.setFieldTouched(field)

    if (form.touched[field]) {
      const rules = validationRulesForForm[field]
      if (rules) {
        form.validateField(field, rules)
      }
    }
  }

  const showSignupSuccess = searchParams.get('message') === 'signup-success'

  return (
    <div className="min-h-screen flex flex-col justify-center py-12 sm:px-6 lg:px-8 bg-gray-50">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <Link href="/" className="flex justify-center items-center mb-6">
          <span className="text-3xl font-bold text-blue-600">Logithm</span>
        </Link>
        <h2 className="text-center text-3xl font-extrabold text-gray-900">
          Sign in to your account
        </h2>
        <p className="mt-2 text-center text-sm text-gray-600">
          Or{' '}
          <Link href="/signup" className="font-medium text-blue-600 hover:text-blue-500">
            create a new account
          </Link>
        </p>
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div className="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
          {showSignupSuccess && (
            <div className="mb-6">
              <Alert
                variant="success"
                title="Account created successfully!"
                message="Please sign in to continue."
              />
            </div>
          )}

          {error && (
            <div className="mb-6">
              <Alert variant="error" message={error} />
            </div>
          )}

          <form className="space-y-6" onSubmit={handleSubmit}>
            <Input
              label="Email address"
              type="email"
              id="email"
              value={form.data.email}
              onChange={(e) => handleFieldChange('email', e.target.value)}
              onBlur={() => handleFieldChange('email', form.data.email)}
              error={form.errors.email}
              autoComplete="email"
              required
            />

            <Input
              label="Password"
              type="password"
              id="password"
              value={form.data.password}
              onChange={(e) => handleFieldChange('password', e.target.value)}
              onBlur={() => handleFieldChange('password', form.data.password)}
              error={form.errors.password}
              autoComplete="current-password"
              required
            />

            <div className="flex items-center justify-between">
              <div className="flex items-center">
                <input
                  id="remember-me"
                  name="remember-me"
                  type="checkbox"
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                />
                <label htmlFor="remember-me" className="ml-2 block text-sm text-gray-900">
                  Remember me
                </label>
              </div>

              <div className="text-sm">
                <Link href="/forgot-password" className="font-medium text-blue-600 hover:text-blue-500">
                  Forgot your password?
                </Link>
              </div>
            </div>

            <div>
              <Button
                type="submit"
                size="lg"
                className="w-full"
                loading={isLoading}
                disabled={isLoading}
              >
                {isLoading ? 'Signing in...' : 'Sign in'}
              </Button>
            </div>
          </form>

          <div className="mt-6">
            <div className="relative">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-gray-300" />
              </div>
              <div className="relative flex justify-center text-sm">
                <span className="px-2 bg-white text-gray-500">New to Logithm?</span>
              </div>
            </div>

            <div className="mt-6">
              <Link href="/signup">
                <Button variant="outline" size="lg" className="w-full">
                  Create your free account
                </Button>
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default function LoginPage() {
  return (
    <Suspense fallback={<div className="min-h-screen flex items-center justify-center">Loading...</div>}>
      <LoginForm />
    </Suspense>
  )
}