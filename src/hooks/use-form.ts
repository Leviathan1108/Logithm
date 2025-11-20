import { useState } from 'react'

interface FormState<T> {
  data: T
  errors: Partial<Record<keyof T, string>>
  touched: Partial<Record<keyof T, boolean>>
  isSubmitting: boolean
}

export function useForm<T extends Record<string, any>>(initialData: T) {
  const [state, setState] = useState<FormState<T>>({
    data: initialData,
    errors: {},
    touched: {},
    isSubmitting: false,
  })

  const setField = (field: keyof T, value: any) => {
    setState(prev => ({
      ...prev,
      data: {
        ...prev.data,
        [field]: value
      },
      errors: {
        ...prev.errors,
        [field]: undefined
      }
    }))
  }

  const setFieldError = (field: keyof T, error: string) => {
    setState(prev => ({
      ...prev,
      errors: {
        ...prev.errors,
        [field]: error
      }
    }))
  }

  const setFieldTouched = (field: keyof T) => {
    setState(prev => ({
      ...prev,
      touched: {
        ...prev.touched,
        [field]: true
      }
    }))
  }

  const setErrors = (errors: Partial<Record<keyof T, string>>) => {
    setState(prev => ({
      ...prev,
      errors
    }))
  }

  const clearErrors = () => {
    setState(prev => ({
      ...prev,
      errors: {}
    }))
  }

  const reset = () => {
    setState({
      data: initialData,
      errors: {},
      touched: {},
      isSubmitting: false,
    })
  }

  const setSubmitting = (isSubmitting: boolean) => {
    setState(prev => ({
      ...prev,
      isSubmitting
    }))
  }

  const validateField = (field: keyof T, rules: Array<(value: any) => string | undefined>) => {
    const value = state.data[field]
    for (const rule of rules) {
      const error = rule(value)
      if (error) {
        setFieldError(field, error)
        return false
      }
    }
    setFieldError(field, '')
    return true
  }

  const validate = (validationRules: Partial<Record<keyof T, Array<(value: any) => string | undefined>>>) => {
    let isValid = true
    const errors: Partial<Record<keyof T, string>> = {}

    for (const [field, rules] of Object.entries(validationRules)) {
      if (rules) {
        const value = state.data[field as keyof T]
        for (const rule of rules) {
          const error = rule(value)
          if (error) {
            errors[field as keyof T] = error
            isValid = false
            break
          }
        }
      }
    }

    setErrors(errors)
    return isValid
  }

  return {
    ...state,
    setField,
    setFieldError,
    setFieldTouched,
    setErrors,
    clearErrors,
    reset,
    setSubmitting,
    validateField,
    validate,
  }
}

// Common validation rules
export const validationRules = {
  required: (message = 'This field is required') => (value: any) => {
    if (!value || (typeof value === 'string' && value.trim() === '')) {
      return message
    }
  },

  email: (message = 'Please enter a valid email') => (value: string) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(value)) {
      return message
    }
  },

  minLength: (min: number, message?: string) => (value: string) => {
    if (value.length < min) {
      return message || `Must be at least ${min} characters long`
    }
  },

  maxLength: (max: number, message?: string) => (value: string) => {
    if (value.length > max) {
      return message || `Must be no more than ${max} characters long`
    }
  },

  matches: (field: string, message = 'Fields must match') => (value: string, formData: any) => {
    if (value !== formData[field]) {
      return message
    }
  },
}