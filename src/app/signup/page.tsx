'use client'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useState, useEffect } from 'react'
import { useForm, validationRules } from '@/hooks/use-form'
import { Button } from '@/components/ui/Button'
import { Input } from '@/components/ui/Input'
import { Alert } from '@/components/ui/Alert'
import { useAuthStore } from '@/store/auth'
import { SignupCredentials } from '@/types'

export default function SignupPage() {
  const router = useRouter()
  const { register, isLoading } = useAuthStore()
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState<string | null>(null)

  const form = useForm<SignupCredentials>({
    email: '',
    username: '',
    password: '',
    confirmPassword: ''
  })

  const validationRulesForForm = {
    email: [
      validationRules.required('Email is required'),
      validationRules.email('Please enter a valid email')
    ],
    username: [
      validationRules.required('Username is required'),
      validationRules.minLength(3, 'Username must be at least 3 characters'),
      validationRules.maxLength(20, 'Username must be no more than 20 characters')
    ],
    password: [
      validationRules.required('Password is required'),
      validationRules.minLength(6, 'Password must be at least 6 characters')
    ],
    confirmPassword: [
      validationRules.required('Please confirm your password'),
      (value: string) => validationRules.matches('password', 'Passwords do not match')(value, form.data)
    ]
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)
    setSuccess(null)

    const isValid = form.validate(validationRulesForForm)
    if (!isValid) {
      return
    }

    try {
      const result = await register(form.data.email, form.data.username, form.data.password, form.data.confirmPassword)

      if (result.success) {
        setSuccess('Account created successfully! Redirecting to dashboard...')
        setTimeout(() => {
          router.push('/dashboard')
        }, 2000)
      } else {
        setError(result.error?.message || 'Registration failed')
      }
    } catch (error) {
      setError('An unexpected error occurred. Please try again.')
    }
  }

  const handleFieldChange = (field: keyof SignupCredentials, value: string) => {
    form.setField(field, value)
    form.setFieldTouched(field)

    if (form.touched[field]) {
      const rules = validationRulesForForm[field]
      if (rules) {
        form.validateField(field, rules)
      }
    }
  }

  return (
    <div className="min-h-screen flex flex-col justify-center py-12 sm:px-6 lg:px-8 bg-gray-50">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <Link href="/" className="flex justify-center items-center mb-6">
          <span className="text-3xl font-bold text-blue-600">Logithm</span>
        </Link>
        <h2 className="text-center text-3xl font-extrabold text-gray-900">
          Create your account
        </h2>
        <p className="mt-2 text-center text-sm text-gray-600">
          Or{' '}
          <Link href="/login" className="font-medium text-blue-600 hover:text-blue-500">
            sign in to your existing account
          </Link>
        </p>
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div className="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
          {error && (
            <div className="mb-6">
              <Alert variant="error" message={error} />
            </div>
          )}

          {success && (
            <div className="mb-6">
              <Alert variant="success" message={success} />
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
              label="Username"
              type="text"
              id="username"
              value={form.data.username}
              onChange={(e) => handleFieldChange('username', e.target.value)}
              onBlur={() => handleFieldChange('username', form.data.username)}
              error={form.errors.username}
              autoComplete="username"
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
              helperText="Must be at least 6 characters"
              autoComplete="new-password"
              required
            />

            <Input
              label="Confirm Password"
              type="password"
              id="confirm-password"
              value={form.data.confirmPassword}
              onChange={(e) => handleFieldChange('confirmPassword', e.target.value)}
              onBlur={() => handleFieldChange('confirmPassword', form.data.confirmPassword)}
              error={form.errors.confirmPassword}
              autoComplete="new-password"
              required
            />

            <div>
              <Button
                type="submit"
                size="lg"
                className="w-full"
                loading={isLoading}
                disabled={isLoading}
              >
                {isLoading ? 'Creating account...' : 'Create account'}
              </Button>
            </div>
          </form>

          <div className="mt-6">
            <div className="relative">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-gray-300" />
              </div>
              <div className="relative flex justify-center text-sm">
                <span className="px-2 bg-white text-gray-500">By signing up, you agree to our</span>
              </div>
            </div>

            <div className="mt-4 text-center text-sm text-gray-600">
              <Link href="/terms" className="font-medium text-blue-600 hover:text-blue-500">
                Terms of Service
              </Link>{' '}
              and{' '}
              <Link href="/privacy" className="font-medium text-blue-600 hover:text-blue-500">
                Privacy Policy
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}